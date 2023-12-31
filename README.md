# xJinx Lua

This is a release of My and @ampx Jinx Lua, a Lua script for Jinx, a champion in the game League of Legends.

## Instructions
1. Add `xJinx.lua` to the lua folder.
2. Add `xCore.lua` to the lua folder.
3. That's it! You're ready to use the script.

## Prerequisites
xCore.lua
DreamPred
DynastyOrb
PkDamagelib

Please note that this release may contain bugs. Your help in testing and reporting any issues is greatly appreciated. If the script is found to be unusable, I will take it down.

## Information
- For questions about how stuff works, crashes, or bugs, please DM me or @jay--. I will respond faster that way.
- The debug/permashow/target selector features are public
- You can watch a video demonstration of the features below

## Features
- Q:
  - Q AOE splash Farm on x minions slider with mana slider and fast clear mode.
  - Q Combo AOE logic.
  - Q Cs minions out of range that will die without rockets (spellfarm).
  - Q Extend Auto attack range by attacking splashable minions (plus visuals).
- W:
  - W on Dash/chain CC/Channel/Zhonyas (unless it needs to evade, or enemy is too close or under enemy tower).
  - W Harass outside auto range.
  - W combo logic (only if it can weave between outattacks, raises DPS, accounts for variable W cast time with attack speed).
  - W Force W semi-manual while in FULL_COMBO (holding control).
  - W KS.
- E:
  - E Dash/Zhonyas/Chain CC/Channel (see W logic exceptions).
  - E Combo multi-hit -> E if it will hit the target and at least one other.
  - E Combo On target if slowed.
  - (Needs more logic)
- R:
  - R KS
  - R Semi-manual ulti, hold U (maybe I'll make it customizable, idk).
  - R option: don't use if enemy has a dash.
  - R MultiHit Combo for damage (if it will hit 3 <65% HP targets and allies can follow up).
  - R Baseult to recall spot if spotted on vision (even if lose vision).
  - R base ult (only if it cannot hit Recall position).

### Damage Visualizer
You can watch a video demonstration of the damage visualizer feature here: [Video Link](https://i.gyazo.com/2ad6840dbcdce81dffb02179eaac1448.mp4)
![Damage Visualizer Screenshot](https://i.gyazo.com/6bc3943b850be7f750b30e96e89d1a74.png)
- Shows R damage in R (if not on cooldown).
- Shows Zap damage in blue (if not on cooldown).
- Shows 3/4 auto attacks in purple (depending on attack speed).
- Text guide on spell usage plus auto to kill (in picture).

### PermaShow
PermaShow is a feature that provides real-time information and status display. It includes the following elements:
- Current Q AOE farm status and extend Harass toggle (A and I keys).
- Shows the active status of fast W mode and Semi-auto Ulti (when holding Control/U keys).
- PermaShow is movable and clickable.

![PermaShow Screenshot](https://i.gyazo.com/92280596846556807abee0259493dede.png)

### Debug Mode
Debug mode is a helpful tool for understanding the script's behavior. It provides on-screen white text messages near the HUD, allowing you to track what the script is thinking. Debug mode has three levels, which can be set using a slider:
- Level 0 (Off): No debug messages displayed.
- Level 1 (Info): Displays some messages.
- Level 2 (Debug): Displays more messages.
- Level 3 (Trace): Displays all messages.

### xTargetSelector
The xTargetSelector is a powerful feature that enhances the functionality of the script. It is considered the best TargetSelector and offers customizable weights. For a better understanding of its capabilities, @ampx could provide more detailed explanations.

![xTargetSelector Screenshot](https://i.gyazo.com/23a4d377ecbc0f551109cdb27f2c7467.png)

Please note that there may be plans to convert this script into jetAIO in the future, depending on available time and interest.

