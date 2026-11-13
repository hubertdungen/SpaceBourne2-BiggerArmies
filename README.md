![Bigger Armies](docs/banner.png)

# Bigger Armies — more men for your faction, and your allies catch rescue pods, in SpaceBourne 2

In SpaceBourne 2 your faction's forces are its generals, and each general leads 4 soldiers. A new
faction gets 10 general slots, 5 for Ground Forces and 5 for Space Forces: 10 squads, 50 men.
"Fifty men isn't exactly an army to conquer the galaxy." Bigger Armies gives your faction more
general slots, so you can field twice as many men. And your allied ships now catch the rescue pods
that drift free after a fight, so you are not the only one who can.

**Links:** [GitHub](https://github.com/hubertdungen/SpaceBourne2-BiggerArmies) ·
[Nexus Mods](https://www.nexusmods.com/spacebourne2/mods/17) · UE4SS Lua mod · works alone or with
the rest of the realism set.
**Install the whole realism set in one go:** the
[SpaceBourne 2 Realism installer](https://github.com/hubertdungen/SpaceBourne2-Realism)
([Nexus](https://www.nexusmods.com/spacebourne2/mods/11)).

## Features

### A bigger army

- **10 more general slots** by default (5 Ground Forces, 5 Space Forces), on top of the game's own.
  Each slot is room for a general and 4 soldiers: 50 more men, 100 in all.
- **Up to 110 men.** The game stops recruiting at 110 people in total, so the mod never goes above
  22 slots (22 squads of 5).

### The game's own way

- **Real slots.** The slots are added with the same function the station upgrade uses, so they look
  and work like the game's slots. Fill them as usual: recruit, promote a soldier to general, give
  them soldiers.
- **Still costs you.** Every recruit costs 200 Faction Power and a daily fee, as in the game.
- **Your faction first.** Nothing happens until you have founded your faction; the slots appear a
  few seconds after that, or after loading a save.

### Ally pod catchers

- **Your allies catch pods too.** In the game only you can catch a rescue pod (the pod catcher item
  or the mothership perk), so pods drift away or time out when you are busy. Now an allied ship
  (fleet or wingmen) that is closer to a free pod than you are, and within range of it, catches it
  with the game's own catcher: the pod flies to the ally and the pilot lands in **your** captives,
  as if you had caught it.
- **Your slots are respected.** Nothing is caught while your captive slots are full, and never more
  than there are free slots. The mothership perk "Mother Pod Catcher" keeps working as before; while
  it is on, the mod leaves the pods to it. Pods near you stay yours to catch.
- **Cheap.** One short check every 2.5 seconds on the game's own thread; the allied ships are only
  looked up while a free pod exists.

### On by default

- No key needed: it works as soon as it is installed. Both parts (bigger army, ally pod catchers)
  have their own switch.

## Requirements

- SpaceBourne 2 (Steam).
- [UE4SS 3.0.1](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/v3.0.1), a free script loader
  for Unreal Engine games (the realism installer installs it for you).

## Install

**A. SpaceBourne 2 Realism installer (recommended)**
Get it on [Nexus](https://www.nexusmods.com/spacebourne2/mods/11) or
[GitHub](https://github.com/hubertdungen/SpaceBourne2-Realism/releases/latest). Tick Bigger Armies
and any other mods of the set: it installs UE4SS if you don't have it, switches the mods on and
keeps them updated.

**B. Manual** (Nexus file, or the zip on the [releases page](https://github.com/hubertdungen/SpaceBourne2-BiggerArmies/releases))
1. Extract the zip into your game folder (`...\SpaceBourne 2`, the one with `SpaceBourne2.exe`).
   It creates `SB2\Binaries\Win64\Mods\BiggerArmies` and switches itself on.
2. No UE4SS yet? Get [RE-UE4SS 3.0.1](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/v3.0.1)
   and copy `dwmapi.dll`, `UE4SS.dll` and `UE4SS-settings.ini` into
   `SpaceBourne 2\SB2\Binaries\Win64\`.

**Uninstall:** untick Bigger Armies in the installer or delete the `BiggerArmies` folder. The slots
already added stay in your save and keep working; the game just stops getting new ones from the mod.

## Settings

Edit `Mods\BiggerArmies\scripts\config.lua`, then restart the game. Every line is optional.

- `Enabled`: `false` switches the mod off.
- `ExtraGeneralSlots` (10): general slots added on top of the game's own, 0–12. They come in pairs,
  one Ground Forces and one Space Forces general (the game adds them that way), so an odd number is
  rounded down. Each slot is room for 5 men.
- `PodCatchers.Enabled` (true): `false` turns the ally pod catchers off.
- `PodCatchers.Range` (5000): how far from an allied ship a pod may be and still be caught, in
  metres (100–50000). The game removes pods that are more than 12.5 km from you.
- `PodCatchers.Interval` (2.5): seconds between checks (1 or more).

## Known limits

- **4 soldiers per general** stays as in the game: the faction screen has exactly 4 soldier places
  per general, and the mod cannot change that screen.
- **Lowering the setting** does not remove slots you already have; the mod only adds.
- **Pod catches go to you.** The pilot lands in your captives; there is no separate account for your
  faction or your allies. A catch also counts for the game's pod catcher mission if it is running.
- **Pods only.** Allies catch free rescue pods; they do not pick up anything else.
- **Battles with many squads** put more soldiers on the field, which costs frames on slower PCs.
  That is the game's own cost; send fewer squads if a big battle runs slowly.

## How it works

The game keeps your general slots in your faction's data and adds one with its own function when
you upgrade your station. A few seconds after a load, the mod counts your slots, works out how many
the game itself gave you, and calls that same function until you have the extra ones. It never
removes anything. The pod catchers look for free pods (the game tags them "FreePod") every few
seconds; when an ally is nearest, the mod calls the pod's own `CatchByMother` with that ally ship,
the same call the mothership perk makes. Details: [DESIGN.md](DESIGN.md). Version history: [CHANGELOG.md](CHANGELOG.md).

## The SpaceBourne 2 realism set

Separate mods that work alone or in any combination. The
[SpaceBourne 2 Realism installer](https://github.com/hubertdungen/SpaceBourne2-Realism)
([Nexus](https://www.nexusmods.com/spacebourne2/mods/11)) installs the ones you tick and keeps them updated.

- **[Hardcore Tactical Realism](https://github.com/hubertdungen/SpaceBourne2-HardcoreTacticalRealism)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/4)): realistic ballistics, wounds and tactical AI. The core of the set.
- **[Silent Ops](https://github.com/hubertdungen/SpaceBourne2-SilentOps)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/6)): stealth, silent takedowns and suppressors.
- **[Ammo Discipline](https://github.com/hubertdungen/SpaceBourne2-AmmoDiscipline)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/12)): carried ammo limits and scavenging, so every magazine counts.
- **[Gear Without Levels](https://github.com/hubertdungen/SpaceBourne2-GearWithoutLevels)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/7)): use gear above your level, with small handling penalties.
- **[Tactical First Person](https://github.com/hubertdungen/SpaceBourne2-TacticalFirstPerson)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/15)): first person on foot, weapons held up, aiming down the sights.
- **[Tactical Engineering](https://github.com/hubertdungen/SpaceBourne2-TacticalEngineering)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/10)): realistic deployable turrets.
- **[Get Out of the Way](https://github.com/hubertdungen/SpaceBourne2-GetOutOfTheWay)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/14)): NPCs step aside naturally when you walk through them.
- **[Ground Waypoints](https://github.com/hubertdungen/SpaceBourne2-GroundWaypoints)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/13)): planet waypoints on foot and on the hoverbike.
- **[Faction Power](https://github.com/hubertdungen/SpaceBourne2-FactionPower)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/9)): dungeons, strategic sales and missions earn your faction power.
- **[Bigger Armies](https://github.com/hubertdungen/SpaceBourne2-BiggerArmies)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/17)): twice the general slots for your faction's ground and space forces.
- **[Clear HUD](https://github.com/hubertdungen/SpaceBourne2-ClearHUD)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/16)): a reticle you can see and HUD colours of your choice.
- **[Split Controls](https://github.com/hubertdungen/SpaceBourne2-SplitControls)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/5)): separate vertical invert for ship and on foot, per device.
- **[SB2 HOTAS](https://github.com/hubertdungen/SpaceBourne2-HOTAS)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/8)): HOTAS, rudder pedals, triple screens and head tracking.
- **[Squad Tactics](https://github.com/hubertdungen/SpaceBourne2-SquadTactics)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/18)): squad orders on foot: teams, point at a spot and give orders, rescue me.
- **[Unofficial Patch](https://github.com/hubertdungen/SpaceBourne2-UnofficialPatch)**
  ([Nexus](https://www.nexusmods.com/spacebourne2/mods/19)): fixes for game bugs, such as squad mates stuck or misplaced in lifts.

## License

MIT. See [LICENSE](LICENSE).
