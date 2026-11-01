--[[
  Bigger Armies for SpaceBourne 2 (UE4SS Lua mod)
  Part of the SpaceBourne 2 realism set.

  Your faction's forces are its generals: each general leads 4 soldiers. The game's own function
  Game_Builder:AddNewGeneralSlot adds TWO slots per call, one Ground Forces general and one Space
  Forces general. A new faction gets 5 calls (10 slots: 10 squads, 50 men), and the station
  upgrade that adds generals calls it once per build or level. This mod calls that same function
  for more slots. See DESIGN.md.

  Saves: the slots are part of your faction's data, so the game saves them. The mod only ever
  ADDS empty slots up to a target; it never removes a slot or touches a general or soldier.
  Without the mod the game keeps the slots you have and works with them.

  Cost: no per-frame work and no object scans. A new player controller (one per load) is noted
  by NotifyOnNewObject; from it the loop reads the Game_Builder and two array lengths, every
  10 s until the faction data is there, then every 30 s.
]]

local VERSION = "0.1.0"

-- Game names (the only things to fix after a game patch) -------------------------------------
local G = {
    PlayerController = "/Script/Engine.PlayerController",
    GameBuilderRef = "GameBuilderRef",                          -- Q1Controller -> Game_Builder
    FactionData = "PlayerFactionData",
    Generals = "Generals_13_F8FC6D4D4F84551840DB838AF2BE10B6",  -- general slots (empty ones too)
    StationBuilds = "PF_StationBuild Data",                    -- station upgrades you built
    UpgradeType = "UpgradeType_2_5D2A7D9F4E826E12635442AD2D68C13F",
    Tier = "Tier_5_30C6F39F436BE19CF3F322AAF993171A",
    GeneralUpgrade = 3,       -- PF_StationUpgrades value whose every build/level adds general slots
    AddSlot = "AddNewGeneralSlot",  -- adds 2 slots: Role 1 (Ground Forces) and Role 2 (Space Forces)
    PerCall = 2,
    BaseCalls = 5,            -- a new faction: 5 calls, 10 slots
    MaxSlots = 22,            -- the game refuses recruits above 110 people: 22 squads of 5
}

-- Folder and log ---------------------------------------------------------------------------
local DIR
do
    local src = debug.getinfo(1, "S").source:gsub("^@", "")
    local cut
    for i in src:lower():gmatch("()[\\/]scripts[\\/]") do cut = i end
    DIR = cut and src:sub(1, cut) or ".\\Mods\\BiggerArmies\\"
end
local LOG = DIR .. "biggerarmies.log"
local verbose = false

local function write(prefix, ...)
    local t = {}
    for i = 1, select("#", ...) do t[#t + 1] = tostring((select(i, ...))) end
    local f = io.open(LOG, "a")
    if f then f:write(os.date("%H:%M:%S "), prefix, table.concat(t, " "), "\n"); f:close() end
    return table.concat(t, " ")
end
local function log(...) if verbose then write("", ...) end end
local function warn(...) print("[BiggerArmies] " .. write("WARN ", ...) .. "\n") end

-- Settings ---------------------------------------------------------------------------------
local defaults = { Enabled = true, ExtraGeneralSlots = 10, Debug = false }
local okCfg, cfg = pcall(require, "config")
if not okCfg or type(cfg) ~= "table" then
    warn("config.lua could not be read (" .. tostring(cfg) .. "); using defaults")
    cfg = {}
end
for k, v in pairs(defaults) do if cfg[k] == nil or type(cfg[k]) ~= type(v) then cfg[k] = v end end
verbose = cfg.Debug == true
-- Slots come in pairs (one ground, one space general): an odd number is rounded down.
local EXTRA = math.max(0, math.min(12, math.floor(cfg.ExtraGeneralSlots / 2) * 2))

if not cfg.Enabled or EXTRA == 0 then
    warn("Bigger Armies " .. VERSION .. " loaded, switched off in config.lua")
    return
end

-- Helpers ----------------------------------------------------------------------------------
local function valid(o)
    if o == nil then return false end
    local ok, v = pcall(function() return o:IsValid() end)
    return ok and v == true
end

-- The newest player controller, kept by path: re-found with StaticFindObject (~0 ms when it
-- exists) so a freed object is never touched.
local pcPath, nextCheck = nil, 0
local added = {}              -- Game_Builder address -> slots this session added to it

-- Slots the game itself hands out: 5 calls, plus 1 call for the general upgrade's build and each
-- of its levels; 2 slots per call. Unreadable upgrades count as none: the mod then adds fewer.
local function vanillaSlots(gb)
    local calls = G.BaseCalls
    local ok, err = pcall(function()
        gb[G.StationBuilds]:ForEach(function(_, e)
            local s = e:get()
            if s[G.UpgradeType] == G.GeneralUpgrade then calls = calls + (tonumber(s[G.Tier]) or 0) + 1 end
        end)
    end)
    if not ok then log("station upgrades unreadable: " .. tostring(err)) end
    return calls * G.PerCall
end

-- Returns the seconds until the next check.
local function check()
    if not pcPath then return 10 end
    local pc = StaticFindObject(pcPath)
    if not valid(pc) then pcPath = nil; return 10 end
    local gb = pc[G.GameBuilderRef]
    if not valid(gb) then return 10 end
    local gens = gb[G.FactionData][G.Generals]
    local have = gens:GetArrayNum()
    if have < G.BaseCalls * G.PerCall then return 10 end -- no faction yet (or still loading)
    local base = vanillaSlots(gb)
    local addr = gb:GetAddress()
    local first = added[addr] == nil
    added[addr] = added[addr] or 0
    -- Never more than the configured extra per world, even if a read went wrong.
    local n = math.min(math.min(base + EXTRA, G.MaxSlots) - have, EXTRA - added[addr])
    local calls = math.floor(n / G.PerCall)
    if calls > 0 then
        for _ = 1, calls do gb[G.AddSlot](gb) end
        added[addr] = added[addr] + calls * G.PerCall
        local now = gb[G.FactionData][G.Generals]:GetArrayNum()
        warn(string.format("general slots %d -> %d (game's own %d): up to %d men", have, now, base, now * 5))
    elseif first then
        log(string.format("general slots %d (game's own %d), nothing to add", have, base))
    end
    return 30
end

NotifyOnNewObject(G.PlayerController, function(pc)
    pcall(function()
        local full = pc:GetFullName()
        pcPath = full:match("^%S+%s+(.+)$") or full
        nextCheck = os.clock() + 15 -- let the save finish loading
        log("player controller " .. pcPath)
    end)
end)

LoopAsync(2000, function()
    if os.clock() < nextCheck then return false end
    nextCheck = os.clock() + 10
    ExecuteInGameThread(function()
        local ok, r = pcall(check)
        if ok then nextCheck = os.clock() + r else warn("check: " .. tostring(r)) end
    end)
    return false
end)

warn(string.format("Bigger Armies %s loaded: +%d general slots (up to %d)", VERSION, EXTRA, G.MaxSlots))
