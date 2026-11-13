# Bigger Armies — design notes

Request (DBK Games Discord, 2026-10-31): "Fifty men isn't exactly an army to conquer the galaxy."
Players want more ground forces for their faction.

## 1. Where the ~50 comes from

Read from the game's Blueprints (SpaceBourne 2, UE 4.27). No decompiled data is in this repository.

- **Your faction's ground forces are its generals.** Each general leads a squad: the faction screen
  (`PF_MemberSlot`) shows exactly **4 soldier slots** per general (indices 0–3), so a squad is
  5 men. Battles take the generals that join an operation, with their soldiers
  (`OperationData.JoinedGenerals`).
- **General slots** live in `Game_Builder.PlayerFactionData.Generals` (an array; an empty slot is
  an entry without a portrait). They are added only by `Game_Builder:AddNewGeneralSlot()`, and
  **each call adds two slots**: one with `Role` 1 (Ground Forces) and one with `Role` 2 (Space
  Forces). Verified in game: a save with 10 slots went to 20 after 5 calls.
  - 5 calls when the faction is set up: 10 slots (5 ground, 5 space);
  - 1 call each time you build or upgrade the station upgrade of type 3
    (`Game_Builder:BuildStation`, `PF_StationUpgrades` value 3).
  So a faction starts with 10 squads × 5 = **50 men**: the number players hit.
- **People cap:** the faction screen refuses new recruits ("Max Capacity") when generals + their
  soldiers + recruits waiting for orders are above **110** (`PlayerFactionOwerview:HowMany`).
  Recruiting also costs 200 Faction Power each (`Game_Builder:AddPeopleToAssignment`).
- Not the cap: `ArmyNumbers` (curve table) sizes the AI families' fleets and defenders, not yours;
  `S_Squad_Data.MaxSoldiers` is unused (0); nothing is in C++.

## 2. Can UE4SS change it safely? Yes

- The slot count is plain saved data, and the game has its own function to add a slot. Calling
  `AddNewGeneralSlot()` from Lua is exactly what the station upgrade does.
- Every screen loops over the array's length (`PlayerFactionOwerview` builds one general card per
  entry), so extra slots show up with no UI change.
- **Saves:** the slots are saved with the faction. The mod never removes a slot and never touches a
  general or a soldier. Removing the mod keeps the slots you have; the game works with any number
  of them. The game itself only rebuilds the slots in a one-time migration for old saves
  (`Game_Builder:CalculateNewGNR`, which demotes generals and recreates 5 + station levels); after
  such a rebuild the mod adds its extra slots again.
- Not done: more than 4 soldiers per general. The 4 is a fixed loop in the faction screen's
  Blueprint, which UE4SS cannot change, and soldiers beyond slot 4 would be invisible there.

## 3. What the mod does

- **Target:** game's own slots (2 × (5 + 1 per build/level of the general upgrade)) +
  `ExtraGeneralSlots` (default 10 = 5 ground + 5 space, range 0–12, rounded down to pairs), never
  above **22** slots: 22 squads × 5 = 110 men, the game's own people cap. More slots could never be
  filled.
- **Only adds:** if the faction has fewer slots than the target, it calls `AddNewGeneralSlot()`
  once per missing pair. Never more than `ExtraGeneralSlots` per loaded world, even if a read went
  wrong (no runaway growth).
- **No faction yet** (fewer than 10 slots): nothing happens; the mod checks again every 10 s, so
  the extra slots appear once you found your faction.
- **Realism / balance:** the default doubles the developed army (about 100 men, a company). Every
  man still costs 200 Faction Power to recruit and a daily fee to keep, so a big army stays a
  choice, not a gift.

## 4. Cost

- `NotifyOnNewObject` on `PlayerController` notes the controller of each load (one callback per
  load). Its path is kept and re-found with `StaticFindObject` (~0 ms when it exists).
- From 15 s after a load: one check every 10 s until the faction data is there, then every 30 s.
  A check reads the Game_Builder, two array lengths and the station upgrades list.
- No per-frame work, no `FindAllOf` / `FindFirstOf`, no hooks.
- Battles: more squads in an operation means more soldiers on the field. That cost is the game's
  own (the same as having more generals); see section 6.

## 5. Settings

`config.lua`: `Enabled`, `ExtraGeneralSlots` (0–12), `Debug` (log to `biggerarmies.log`). No key:
there is nothing to switch during play.

## 6. Related, not changed: battle spawn caps

Another session (Get Out of the Way, `side-session-notes\...\ground-forces-cap.md`) looked at the
ground battles themselves: `BattleBorders_C` sets per-battle caps from the castle level
(`BarracksMaxSpawn = 5`, `JetPackMaxSpawn` from a curve clamped to 1–5, drone caps), copied by
`DefenderRusherSpawner_C` and `Solder_Spliner_C`. Those limit the defenders' reinforcements in a
siege, not the size of your faction. The player's side spawns from the squads of the joined
generals, so more general slots is the lever for "more men"; bigger reinforcement waves would be a
separate mod (and a frame question: ~100 ALS soldiers with HTR and Silent Ops hooks).

## 7. Tested in game

**2026-11-01, test 1** (test slot `BGATest`, a copy of the user's latest save, which has a faction:
6 generals, 22 soldiers, 8963 Faction Power; with HTR, Split Controls, Silent Ops, Gear Without
Levels, Faction Power, Tactical Engineering, Ammo Discipline, Get Out of the Way and Ground
Waypoints installed; SB2HOTAS 0):
- 15 s after the load the mod found the faction: **10 slots → 20** with 5 calls
  (`general slots 10 -> 20`); the 6 generals and 22 soldiers untouched.
- A second check 35 s later added nothing (target reached).
- The reads take less than 1 ms (below `os.clock` resolution); one check every 30 s.
- The user's saves: identical before and after (81 files hashed).
- Found here: each `AddNewGeneralSlot()` call adds 2 slots (ground + space). The code now counts
  in pairs; that build added 10 slots too, the same result for this save.

**Test 2, stopped:** faction screen screenshot, save into the test slot, reload without the mod.
The game died about 20 s after start, before the main menu (no crash report; the PC was on
TeamViewer, the known start-up hang). Restored at once; saves identical.

**Test 3** (21:41, the release build counting in pairs, same save copy and mods): `general slots
10 -> 20 (game's own 10): up to 100 men`; 6 generals and 22 soldiers kept; the faction page
opened (`OpenMainWidget` + `OpenFaction`) without errors; saves identical (81 files).

Not verified in game:
- The faction overview listing the 20 cards: the probe found the overview widget not yet built
  (0 cards), and the screen capture showed the desktop, not the game. Budget allowed one launch.
- Save and reload **without the mod**. By design the slots are the faction's own saved data (the
  user's 10 slots and their generals came back from the save), and every screen loops over the
  array, so they should stay; this was not run.
- A ground battle with many squads, and its frames.
