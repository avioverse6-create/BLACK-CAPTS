# Optional character model

The project can load a rigged pedestrian model without Blender.

1. Download the **LOD2 GLB** from the model page:
   https://tevy.dev/models/casual-walker
2. Use the pinned direct file:
   https://tevy.dev/models/casual-walker/v1/lod2.glb
3. In the Godot project, create `assets/characters/`.
4. Put the downloaded file there and name it exactly `casual-walker.glb`.
5. Reopen the project in Godot so it imports the GLB.

The player and all town pedestrians automatically use this file when it exists. The scripts look for animation clips named `idle` and `walk` (case-insensitive). If the file is absent, the prototype keeps its simple placeholder visuals.

**License:** the model page lists the asset as CC0 1.0. It is an independently made game-ready character, not a Rockstar/GTA model. The model is a modern casual hoodie-and-jeans character, so it is a temporary technical character until a closer SA-MP-era visual match is sourced.

Source: https://tevy.dev/models/casual-walker
License: CC0 1.0


## Retro urban environment models

A promising environment pack is Kenney's **Retro Urban Kit**:
- https://opengameart.org/content/retro-urban-kit
- 120 early-3D urban objects, low-resolution textures, GLB/FBX/OBJ.
- CC0 license; attribution is optional.

This pack has not yet been imported. It is an independent PS1-era asset set, not original GTA San Andreas content. Environment models should be added under `assets/environment/` after the archive is obtained and each GLB has been checked in Godot. Do not replace the existing map until scale, collision and mobile performance are tested.
