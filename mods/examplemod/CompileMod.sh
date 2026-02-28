#!/usr/bin/env bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# default metadata; override by setting environment variables before invoking
NAME=${NAME:-"Example Mod"}
VERSION=${VERSION:-"1.0"}
AUTHOR=${AUTHOR:-"Your Name"}
MODID=${MODID:-"examplemod"}
DESCRIPTION=${DESCRIPTION:-"An example mod for AstroClient."}
MAINCLASS=${MAINCLASS:-"com.example.ExampleMod"}

# write .amt file used by the loader
cat > src/main/resources/example.amt <<EOF
name=$NAME
version=$VERSION
author=$AUTHOR
modid=$MODID
description=$DESCRIPTION
mainClass=$MAINCLASS
EOF

echo "Generated metadata (example.amt):"
cat src/main/resources/example.amt

echo "Building mod..."
if command -v gradle >/dev/null 2>&1; then
  gradle assembleMod
else
  ./gradlew assembleMod
fi

# copy compiled jar into an ams so the loader has something to run
JARFILE="build/libs/${MODID}.jar"
if [ -f "$JARFILE" ]; then
  mkdir -p build/libs
  cp "$JARFILE" "build/libs/logic.ams"
  echo "Copied $JARFILE to build/libs/logic.ams"
fi

# copy any resource .ams into build/libs (if present)
if compgen -G "src/main/resources/*.ams" > /dev/null 2>&1; then
  cp src/main/resources/*.ams build/libs/ 2>/dev/null || true
fi

# copy example.amt into build/libs then create zip
if [ -f src/main/resources/example.amt ]; then
  cp src/main/resources/example.amt build/libs/
fi

if [ -d build/libs ]; then
  (cd build/libs && zip -r "${MODID}.zip" example.amt *.ams 2>/dev/null) || (
    echo "zip failed or not found, attempting jar to create zip"
    (cd build/libs && jar -cf "${MODID}.zip" .)
  )
  echo "Done - output zip is build/libs/${MODID}.zip"
else
  echo "Build output directory not found; did assembleMod succeed?"
fi