# Asset plan — BLACK-CAPTS

The project should use ready-made, properly licensed assets wherever possible. Do not replace the temporary blockout with hand-built primitive models unless a required asset is unavailable.

## Target asset groups

| In-game use | Preferred asset type | Import target |
|---|---|---|
| Roads, sidewalks, road markings | Modular low-poly road kit | `assets/environment/roads/` |
| 2–3 town buildings | Modular city/suburban building kit | `assets/environment/buildings/` |
| Snowy trees and street props | Low-poly nature/urban props | `assets/environment/props/` |
| Player and NPCs | Rigged humanoid models with locomotion clips | `assets/characters/` |
| Snow | Lightweight particle texture/material | `assets/effects/` |

## Candidate sources

- **Kenney** — https://kenney.nl/assets  
  Check the exact asset page and the `License.txt` included in each downloaded pack. Packs marked CC0 can be incorporated into the game. Good first place to look for modular roads, buildings, and environment props.
- **Quaternius** — https://quaternius.com/  
  Check the current pack terms before importing. The current Quaternius Asset License allows incorporation into personal, educational, and commercial projects, but does not allow redistribution of the asset files as a standalone pack. License: https://quaternius.com/license.html
- **Poly Haven** — https://polyhaven.com/  
  Use for CC0 materials and environment textures; check the asset page and preserve the license record.

## Import checklist

For every downloaded asset, add a small `SOURCE.md` beside it containing:
1. Original asset page URL.
2. Creator / publisher.
3. Exact license name and a copy of the license file or its URL.
4. Date obtained.
5. Any required attribution.

Prefer glTF 2.0 (`.glb`) for Godot imports. Keep textures reasonably sized, remove unused materials, and use collision meshes suited to mobile performance.

## Important

Do not use leaked, ripped, or extracted proprietary game files without permission. A similar overall visual direction is fine; copied game UI, maps, or models are not. The current scene still contains temporary placeholders until approved assets are imported and tested on Android.
