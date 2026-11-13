--[[
  Pod catchers for allies (Bigger Armies 0.2.0).

  The game gives the pod catcher to the player only: the item "Use_PodCatcher" and the mothership perk
  "Mother Pod Catcher" (Q1_Master_Ship:MotherPodCatcher, every 10 s it takes a free pod and calls the
  pod's own CatchByMother). Allied ships catch nothing, so rescue pods drift away or time out.

  Here: every few seconds on the game thread (gametick.lua, no LoopAsync), find the free pods
  (MasterPod_C, tag "FreePod"). A pod that is closer to an allied ship than to you, and inside
  PodCatchers.Range of that ship, is caught with the game's own MasterPod:CatchByMother(ally ship): the
  pod flies to the ally, the game's own drone cable animation plays and the pilot lands in YOUR
  captives (Q1_Master_Ship.Captives), exactly like your own catch.

  Not done when: the mothership perk is on (it already takes every free pod), your captive slots are full,
  the pod is not started yet or already being caught. Cost: one FindAllOf per tick; the ship scan only runs
  while a free pod exists.
]]

local P = {}

local POD, ALLY_SHIP, CONTROLLER = "MasterPod_C", "Master_Enemy_C", "Q1Controller_C"
local AI_ALLY = 1
local FLIGHT = 12  -- seconds a caught pod needs to reach the ship; counts against the free captive slots
local REMEMBER = 90 -- seconds a pod we caught stays on the "already caught" list

local function valid(o)
    if o == nil then return false end
    local ok, v = pcall(function() return o:IsValid() end)
    return ok and v == true
end

local function prop(o, name, default)
    local ok, v = pcall(function() return o[name] end)
    if ok and v ~= nil then return v end
    return default
end

-- Destroyed actors stay valid for IsValid() until the garbage collector runs: they keep their tags and report
-- the world origin as their place (test 2026-11-13: a destroyed pod and a destroyed ally "0.0 km" apart were
-- caught again and again). So: not being destroyed, and not sitting exactly on the origin.
local function alive(o)
    if not valid(o) then return false end
    local ok, dying = pcall(function() return o:IsActorBeingDestroyed() end)
    if ok and dying == true then return false end
    local okL, l = pcall(function() return o:K2_GetActorLocation() end)
    if okL and l and l.X == 0 and l.Y == 0 and l.Z == 0 then return false end
    return true
end

local function hasTag(pod, tag)
    local ok, tags = pcall(function() return pod.Tags end)
    if not ok or tags == nil then return false end
    local found = false
    pcall(function()
        tags:ForEach(function(_, e)
            local okS, s = pcall(function() return e:get():ToString() end)
            if okS and s == tag then found = true end
        end)
    end)
    return found
end

-- Your ship: the pawn of the player controller (FindFirstOf on the ship class also returns other objects of
-- the class, with no captive list). On foot the pawn is a character, which has no Captives: nothing to do.
local function playerShip()
    local pc = FindFirstOf(CONTROLLER)
    if not valid(pc) then return nil end
    local ok, pawn = pcall(function() return pc.Pawn end)
    if not ok or not valid(pawn) then return nil end
    if prop(pawn, "Captives", nil) == nil then return nil end
    return pawn
end

local function dist2(a, b)
    local dx, dy, dz = a.X - b.X, a.Y - b.Y, a.Z - b.Z
    return dx * dx + dy * dy + dz * dz
end

local function loc(o)
    local ok, v = pcall(function() return o:K2_GetActorLocation() end)
    if ok and v and v.X then return { X = v.X, Y = v.Y, Z = v.Z } end
    return nil
end

--- start(GT, cfg, log, warn): cfg = { Enabled, Range (metres), Interval (s) }
function P.start(GT, cfg, log, warn)
    if not cfg.Enabled then log("pod catchers off in config.lua") return end
    local range2 = (cfg.Range * 100) ^ 2 -- metres -> UE units (cm)
    local recent = {}                    -- os.clock() of the last catches (slots in flight)
    local lastFull = false
    local caught = 0
    local done = {}                      -- full name of a pod we caught -> os.clock(): never caught twice

    local function tick()
        local pods = FindAllOf(POD)
        if not pods or #pods == 0 then return end
        local t0 = os.clock()
        for name, t in pairs(done) do if t0 - t > REMEMBER then done[name] = nil end end
        local free = {}
        for _, pod in ipairs(pods) do
            if alive(pod) and prop(pod, "Started", false) == true and prop(pod, "PodSpawned", false) ~= true
                and hasTag(pod, "FreePod") then
                local okN, name = pcall(function() return pod:GetFullName() end)
                if okN and not done[name] then free[#free + 1] = { actor = pod, name = name } end
            end
        end
        if #free == 0 then return end

        local ship = playerShip()
        if not ship then return end
        if prop(ship, "MoahterPodCathcerActive", false) == true then return end -- the perk takes every free pod

        local now = os.clock()
        local kept = {}
        for _, t in ipairs(recent) do if now - t < FLIGHT then kept[#kept + 1] = t end end
        recent = kept
        local used, max = #recent, 0
        local okC, n = pcall(function() return ship.Captives:GetArrayNum() end)
        if okC then used = used + n end
        max = tonumber(prop(ship, "Max Captive", 0)) or 0
        if max <= 0 then return end -- unknown slot count: better to leave the pods alone
        if used >= max then
            if not lastFull then log("captive slots full (" .. used .. "/" .. max .. "): allies leave the pods alone") end
            lastFull = true
            return
        end
        lastFull = false

        local pl = loc(ship)
        if not pl then return end
        local allies = FindAllOf(ALLY_SHIP)
        if not allies then return end
        local live = {}
        for _, a in ipairs(allies) do
            if alive(a) and prop(a, "AITypes", -1) == AI_ALLY and prop(a, "Dead?", false) ~= true then
                local l = loc(a)
                if l then live[#live + 1] = { actor = a, loc = l } end
            end
        end
        if #live == 0 then return end

        for _, f in ipairs(free) do
            local pod = f.actor
            if used >= max then break end
            local pp = loc(pod)
            if pp then
                local best, bestD = nil, math.huge
                for _, a in ipairs(live) do
                    local d = dist2(a.loc, pp)
                    if d < bestD then best, bestD = a, d end
                end
                if best and bestD <= range2 and bestD < dist2(pl, pp) then
                    local ok, err = pcall(function() pod:CatchByMother(best.actor) end)
                    if ok then
                        done[f.name] = os.clock()
                        caught = caught + 1
                        used = used + 1
                        recent[#recent + 1] = now
                        log(string.format("ally ship caught a pod %.1f km away (%d so far, slots %d/%d) %s", 
                            math.sqrt(bestD) / 100000, caught, used, max, (f.name:gsub("^.*%.", ""))))
                    else
                        warn("pod catch: " .. tostring(err))
                    end
                end
            end
        end
    end

    local interval = math.max(1, cfg.Interval or 2.5)
    GT.every(interval, function()
        local ok, err = pcall(tick)
        if not ok then warn("pod catch tick: " .. tostring(err)) end
    end)
    log(string.format("pod catchers on: range %d m, every %.1f s", cfg.Range, interval))
end

return P
