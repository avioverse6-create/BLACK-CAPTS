# Bundled 3D asset licenses

The Android build downloads these assets during CI and embeds them in the APK. The game does not fetch assets at runtime and remains playable offline.

## Kenney assets

- Source library: https://github.com/Hidencod/tge-assets
- Pinned source revision: `e5bd31ec8b339b25d66dd5816a21dd517bd1ae87`
- Original creator: Kenney
- License: CC0 1.0
- Included groups: City Kit (Roads), City Kit (Suburban), City Kit (Commercial), and Car Kit.
- Original license and pack pages: https://kenney.nl/assets/city-kit-roads, https://kenney.nl/assets/city-kit-suburban, https://kenney.nl/assets/city-kit-commercial, https://kenney.nl/assets/car-kit

## Casual Walker character

- Source page: https://tevy.dev/models/casual-walker
- Download: https://tevy.dev/models/casual-walker/v1/lod2.glb
- License: CC0 1.0
- Includes a 56-bone humanoid rig and idle, walk, wave, and look-around animations.
- This is an independent original character, not a GTA or SA-MP character model.

All files are downloaded by `scripts/download_assets.sh` for packaging. If an upstream asset is unavailable, the Android build fails rather than silently packaging placeholder geometry.
