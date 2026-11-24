# GTA San Andreas-style asset pipeline

## Goal
Build the BLACK-CAPTS world with the original low-poly GTA San Andreas / SA-MP visual language: textured buildings, road pieces, street props, pedestrians, and matching animation style. The current Godot scene is still a primitive blockout.

## Important asset boundary
The tools below are importers/editors, not redistributable collections of Rockstar game assets. They expect files from a game installation supplied by the user. Do not upload original GTA archives, extracted Rockstar models, textures, or converted copies to this public repository. Keep any locally sourced game assets outside version control and check the rights that apply before distributing a build.

## Researched tools

### INU Tools (GTA SA)
- Project: https://github.com/INU-ez/INU_Tools-GTA-Blender
- Blender extension: https://extensions.blender.org/add-ons/inu-tools-gta-sa/
- Handles DFF, COL, TXD, IDE, IPL, IMG, and IFP formats; supports map import and skinned pedestrian/animation workflows.
- The extension code is GPL-3.0-or-later. That license applies to the tool, not to Rockstar game assets read by the tool.
- Best candidate for preparing a selected map area and character/animation assets in Blender.

### GTA SA Toolkit
- Project: https://github.com/LiorKag/GTA-SA-Toolkit
- Extension page: https://extensions.blender.org/add-ons/gta-sa-toolkit/
- Reads map areas, objects, pedestrians, and animations from a user's own PC installation. It contains no game files.
- Useful for selecting a compact area instead of importing an entire world.

### DragonFF
- Project: https://github.com/Parik27/DragonFF
- Blender extension page: https://extensions.blender.org/add-ons/dragonff/
- Imports/exports RenderWare DFF models, TXD textures, COL collision, and partial IDE/IPL map data.
- Useful as a secondary importer when an asset needs inspection or repair.

## Planned Godot folders
- `assets/gta_style/environment/buildings/`
- `assets/gta_style/environment/roads/`
- `assets/gta_style/environment/props/`
- `assets/gta_style/characters/`
- `assets/gta_style/animations/`
- `assets/gta_style/materials/`

Use GLB/glTF for Godot imports after conversion and cleanup. Keep collision geometry simple. Reuse a compatible pedestrian skeleton for NPCs where possible. Build only a small map slice first and profile it on the target Android device.

## Integration sequence
1. Select a small winter-town block / street area.
2. Prepare only the required environment models and textures in Blender.
3. Export cleaned models as GLB, preserving texture paths and scale.
4. Import the GLBs into Godot and replace the primitive road/building/tree placeholders.
5. Prepare one compatible pedestrian rig and a small set of locomotion animations.
6. Reuse the pedestrian scene for the player and NPCs.
7. Test draw calls, texture memory, collisions, and frame rate on Android.

## Current limitation
No original game archive or extracted model files are available in this repository or in this chat. Therefore no authentic GTA model can be imported yet. The current project remains a blockout until a lawful source asset set is available. The Blender tools themselves require a desktop Blender workflow; they are not Android/Godot importers.
