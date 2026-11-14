# Changelog

## 0.2.1 — 2026-11-13

- The ally pod catchers (added in 0.2.0, a GitHub-only release of 2026-11-13) are **not** part of Bigger Armies: they moved to the new
  [Hardcore Space Realism](https://www.nexusmods.com/spacebourne2/mods/20). This version is 0.1.2 with the version number moved on.
  If you installed 0.2.0, update to this one and get Hardcore Space Realism: with both installed there are no double catches
  (Hardcore Space Realism leaves the pods to Bigger Armies 0.2.0 while that is on).
- README: the realism set list now includes Hardcore Space Realism, Squad Tactics and Unofficial Patch.

## 0.1.2 — 2026-11-06

- **Fix: a "Fatal Error!" crash that could come at any moment.** The mod's check ran on a UE4SS
  background thread. When two mods of the set did that at the same moment, UE4SS's own bookkeeping
  broke and the game crashed. It now runs on the game's own thread, driven by the game's tick on
  foot and in your ship (the same fix in every mod of the realism set).
- Tested in game with the whole realism set (13 mods together, a few minutes on foot): no crash,
  and every mod's timed work ran.

## 0.1.1 — 2026-11-06

- **Fix: a possible crash while a level loads.** The mod noticed the player controller through a
  UE4SS feature that runs on the game's loading thread, and that could crash the game
  ("Fatal Error!") during a level load. It now notices it when you take control of your character,
  on the game's own thread.
- Tested in game with the whole realism set: no crash, general slots raised as before (10 -> 20).

## 0.1.0 — 2026-11-01

First release.

- 10 more general slots for your faction by default (`ExtraGeneralSlots`, 0–12): each is room for
  a general and 4 soldiers, so about 100 men instead of 50.
- Added with the game's own function (the one the station upgrade uses); never more than 22 slots,
  the game's own 110-people limit.
- Only adds empty slots; never removes a slot or touches a general or soldier. Removing the mod
  keeps the slots you have.
- Waits until your faction exists. No key, no per-frame work.
