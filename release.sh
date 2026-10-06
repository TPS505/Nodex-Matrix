#!/bin/bash
# Build the firmware and publish it for over-the-air updates.
# Usage: bump "version:" in nodex-matrix.yaml, then run ./release.sh, then commit + push.
set -e
# The native hub75 driver and the provisioning window need ESPHome 2026.9+.
# Home Assistant must be 2026.x to list every entity from firmware this new.
ESPHOME_VERSION=2026.9.1
if [ "$(esphome version | awk '{print $2}')" != "$ESPHOME_VERSION" ]; then
  echo "Need ESPHome $ESPHOME_VERSION for releases:  pip install esphome==$ESPHOME_VERSION"; exit 1
fi
YAML=nodex-matrix.yaml
NAME=nodex-matrix
OUT=docs/firmware

VERSION=$(grep -E '^\s*version:' "$YAML" | head -1 | sed -E 's/.*"(.*)".*/\1/')
echo "Building $NAME $VERSION ..."
esphome compile "$YAML"

BUILD=.esphome/build/$NAME/build
mkdir -p "$OUT"
cp "$BUILD/firmware.ota.bin"     "$OUT/$NAME.ota.bin"
cp "$BUILD/firmware.factory.bin" "$OUT/$NAME.factory.bin"
MD5=$(md5 -q "$OUT/$NAME.ota.bin" 2>/dev/null || md5sum "$OUT/$NAME.ota.bin" | cut -d' ' -f1)

cat > "$OUT/manifest.json" <<JSON
{
  "name": "Nodex Matrix",
  "version": "$VERSION",
  "home_assistant_domain": "esphome",
  "new_install_prompt_erase": false,
  "builds": [
    {
      "chipFamily": "ESP32-S3",
      "parts": [ { "path": "$NAME.factory.bin", "offset": 0 } ],
      "ota": {
        "path": "$NAME.ota.bin",
        "md5": "$MD5",
        "summary": "Nodex Matrix firmware $VERSION",
        "release_url": "https://github.com/TPS505/Nodex-Matrix/releases"
      }
    }
  ]
}
JSON
echo "Done: $OUT/manifest.json -> version $VERSION. Now: git add docs && git commit -m 'Release $VERSION' && git push"
