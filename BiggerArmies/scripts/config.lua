--[[
  Bigger Armies for SpaceBourne 2
  ===============================
  USER SETTINGS. Edit with any text editor, then restart the game.
  Everything here is optional: delete a line and the default is used.
]]

return {
    -- false = the mod does nothing at all.
    Enabled = true,

    -- General slots added to your faction on top of the game's own (10: 5 Ground Forces and
    -- 5 Space Forces, plus 2 for each level of the station upgrade that adds generals).
    -- They come in pairs, one ground and one space general: 10 = 5 + 5. 0 - 12.
    -- Each general leads 4 soldiers, so every slot is room for 5 more men. The game stops
    -- recruiting at 110 people in total (generals, their soldiers and recruits waiting for
    -- orders), so the mod never goes above 22 slots.
    ExtraGeneralSlots = 10,

    -- Pod catchers for your allies. Rescue pods drift free after a ship is shot down; only YOU could
    -- catch them (item or mothership perk). With this on, an allied ship (fleet or wingmen) that is
    -- closer to a free pod than you are, and within Range of it, catches it with the game's own
    -- catcher. The pilot lands in YOUR captives, as if you had caught it. Not done while your captive
    -- slots are full or while your mothership perk "Mother Pod Catcher" is on (it takes every pod).
    PodCatchers = {
        Enabled = true,
        Range = 5000,       -- metres from the allied ship to the pod (100 - 50000)
        Interval = 2.5,     -- seconds between checks (1 or more)
    },

    Debug = false,          -- true: writes details to biggerarmies.log in the mod folder
}
