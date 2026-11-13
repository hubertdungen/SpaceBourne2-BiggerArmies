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

    Debug = false,          -- true: writes details to biggerarmies.log in the mod folder
}
