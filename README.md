![Bigger Armies](docs/banner.png)

# Bigger Armies — more ground forces for your faction in SpaceBourne 2

In SpaceBourne 2 your faction's forces are its generals, and each general leads 4 soldiers. A new
faction gets 10 general slots, 5 for Ground Forces and 5 for Space Forces: 10 squads, 50 men.
"Fifty men isn't exactly an army to conquer the galaxy." Bigger Armies gives your faction more
general slots, so you can field twice as many men.

Version 0.1.1 · [Nexus Mods page](https://www.nexusmods.com/spacebourne2/mods/17) · UE4SS Lua mod · works alone or with the rest of the
[realism set](#part-of-the-spacebourne-2-realism-set).

## What it does

- **10 more general slots** by default (5 Ground Forces, 5 Space Forces), on top of the game's
  own. Each slot is room for a general and 4 soldiers: 50 more men, 100 in all.
- **The game's own way:** the slots are added with the same function the station upgrade uses, so
  they look and work like the game's slots. Fill them as usual: recruit, promote a soldier to
  general, give them soldiers.
- **Still costs you:** every recruit costs 200 Faction Power and a daily fee, as in the game.
- **Up to 110 men:** the game stops recruiting at 110 people in total, so the mod never goes above
  22 slots (22 squads of 5).
- **Your faction first:** nothing happens until you have founded your faction; the slots appear a
  few seconds after that, or after loading a save.
- **On by default.** No key needed.

## Requirements

- SpaceBourne 2 (Steam).
- [UE4SS 3.0.1](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/v3.0.1), a free script loader
  for Unreal Engine games.

## Install

**Option A (recommended):** the [SpaceBourne 2 Realism](https://www.nexusmods.com/spacebourne2/mods/11)
installer installs UE4SS and any mods of the set you pick.

**Option B, manual:**

1. Install [UE4SS 3.0.1](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/v3.0.1) into
   `SpaceBourne 2\SB2\Binaries\Win64\`.
2. Download `BiggerArmies-0.1.1.zip` from the
   [releases](https://github.com/hubertdungen/SpaceBourne2-BiggerArmies/releases) and extract it into
   the game folder (`...\steamapps\common\SpaceBourne 2\`). It adds
   `SB2\Binaries\Win64\Mods\BiggerArmies\`; the `enabled.txt` inside turns it on.

Uninstall: delete `SB2\Binaries\Win64\Mods\BiggerArmies`. The slots already added stay in your
save and keep working; the game just stops getting new ones from the mod.

## Settings

Edit `Mods\BiggerArmies\scripts\config.lua`, then restart the game. Every line is optional.

- `Enabled`: `false` switches the mod off.
- `ExtraGeneralSlots` (10): general slots added on top of the game's own, 0–12. They come in pairs,
  one Ground Forces and one Space Forces general (the game adds them that way), so an odd number is
  rounded down. Each slot is room for 5 men.

## Known limits

- **4 soldiers per general** stays as in the game: the faction screen has exactly 4 soldier places
  per general, and the mod cannot change that screen.
- **Lowering the setting** does not remove slots you already have; the mod only adds.
- **Battles with many squads** put more soldiers on the field, which costs frames on slower PCs.
  That is the game's own cost; send fewer squads if a big battle runs slowly.

## How it works

The game keeps your general slots in your faction's data and adds one with its own function when
you upgrade your station. A few seconds after a load, the mod counts your slots, works out how many
the game itself gave you, and calls that same function until you have the extra ones. It never
removes anything. Details: [DESIGN.md](DESIGN.md).

<!-- nexus:skip -->
## Status

Tested in game on 2026-11-01 on a copy of a real save with a faction (6 generals, 22 soldiers),
with HTR and eight other set mods installed: slots 10 → 20 a few seconds after the load, generals and
soldiers untouched, a second check adds nothing, saves untouched. Not yet tested: reloading a save
without the mod, and a big ground battle. Details: [DESIGN.md](DESIGN.md), section 7.
0.1.1 (the player controller from PlayerController:ClientRestart on the game thread instead of
NotifyOnNewObject) was smoke-tested on 2026-11-06 with the whole set: no crash, slots 10 -> 20.
<!-- /nexus:skip -->

## Part of the SpaceBourne 2 realism set

Part of the realism set, built around [Hardcore Tactical Realism](https://www.nexusmods.com/spacebourne2/mods/4)
as the core mod. HTR is not required: this mod works on its own or with any of the others.
To install them all at once, use the installer:
[SpaceBourne 2 Realism](https://github.com/hubertdungen/SpaceBourne2-Realism)
([Nexus](https://www.nexusmods.com/spacebourne2/mods/11)).

| Mod | Status |
|---|---|
| **Hardcore Tactical Realism (HTR)** — realistic ballistics and tactical AI | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-HardcoreTacticalRealism) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/4) · [Steam discussion](https://steamcommunity.com/app/1646850/discussions/0/573805072991123580) |
| **Split Controls** — separate invert for ship and on foot | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-SplitControls) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/5) |
| **Silent Ops** — realistic stealth | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-SilentOps) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/6) |
| **Gear Without Levels** — use gear regardless of level | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-GearWithoutLevels) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/7) |
| **SB2 HOTAS** — HOTAS, triple screens, head tracking | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-HOTAS) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/8) |
| **Faction Power** — your deeds earn your faction power | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-FactionPower) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/9) |
| **Tactical Engineering** — realistic deployable turrets | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-TacticalEngineering) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/10) |
| **Ammo Discipline** — realistic ammo limits and scavenging | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-AmmoDiscipline) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/12) |
| **Ground Waypoints** — planet markers on foot and on the hoverbike | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-GroundWaypoints) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/13) |
| **Get Out of the Way** — NPCs step aside naturally | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-GetOutOfTheWay) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/14) |
| **Tactical First Person** — first-person on foot | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-TacticalFirstPerson) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/15) |
| **Bigger Armies** — more ground forces for your faction (this mod) | released: [GitHub](https://github.com/hubertdungen/SpaceBourne2-BiggerArmies) · [Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/17) |

## License

MIT. See [LICENSE](LICENSE).
