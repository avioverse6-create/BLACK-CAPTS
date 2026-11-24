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

# Godot 4.4 does not import Tevy's Meshopt/quantized GLB directly.
# Decode EXT_meshopt_compression and remove KHR_mesh_quantization while
# preserving the rig and animation clips, then replace the source asset.
TOOLS_DIR="$(mktemp -d)"
trap 'rm -rf "$TOOLS_DIR"' EXIT
npm install --silent --prefix "$TOOLS_DIR" \
  @gltf-transform/core@4 \
  @gltf-transform/extensions@4 \
  @gltf-transform/functions@4 \
  meshoptimizer
cat > "$TOOLS_DIR/convert.mjs" <<'EOF'
import { NodeIO } from '@gltf-transform/core';
import { EXTMeshoptCompression } from '@gltf-transform/extensions';
import { dequantize } from '@gltf-transform/functions';
import { MeshoptDecoder } from 'meshoptimizer';

await MeshoptDecoder.ready;
const io = new NodeIO()
  .registerExtensions([EXTMeshoptCompression])
  .registerDependencies({ 'meshopt.decoder': MeshoptDecoder });
const input = process.argv[2];
const output = process.argv[3];
const document = await io.read(input);
await document.transform(dequantize());
await io.write(output, document);
console.log('Converted character GLB for Godot 4.4:', output);
EOF
node "$TOOLS_DIR/convert.mjs" \
  "assets/characters/casual-walker.glb" \
  "$TOOLS_DIR/casual-walker-godot.glb"
mv "$TOOLS_DIR/casual-walker-godot.glb" "assets/characters/casual-walker.glb"

echo "Bundled GLB assets:"
find assets/kenney assets/characters -name '*.glb' -printf '%p %k KB\n' | sort
