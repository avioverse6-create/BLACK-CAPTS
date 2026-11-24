#!/usr/bin/env bash
set -euo pipefail

# Download only openly licensed, lightweight GLB assets.
# The APK contains these files locally; the game makes no runtime network requests.
BASE="https://raw.githubusercontent.com/Hidencod/tge-assets/e5bd31ec8b339b25d66dd5816a21dd517bd1ae87"
ROOT="assets/kenney"

download() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  curl --fail --location --retry 3 --silent --show-error "$source" -o "$target"
  test -s "$target"
}

# Modular road pieces.
for model in road-straight road-crossroad road-side road-crossing; do
  download "$BASE/packs/city-kit-roads/$model.glb" "$ROOT/roads/$model.glb"
done

# Full building models (not box placeholders).
for model in building-type-a building-type-b building-type-c building-type-d building-type-e building-type-f; do
  download "$BASE/packs/city-kit-suburban/$model.glb" "$ROOT/buildings/$model.glb"
done
download "$BASE/packs/city-kit-commercial/building-a.glb" "$ROOT/buildings/building-commercial-a.glb"

# Environment and a parked vehicle model.
download "$BASE/packs/city-kit-suburban/tree-large.glb" "$ROOT/props/tree-large.glb"
download "$BASE/packs/car-kit/sedan.glb" "$ROOT/vehicles/sedan.glb"

# Rigged character with idle, walk, wave and look-around animations (CC0).
download "https://tevy.dev/models/casual-walker/v1/lod2.glb" "assets/characters/casual-walker.glb"

echo "Bundled GLB assets:"
find assets/kenney assets/characters -name '*.glb' -printf '%p %k KB\n' | sort
