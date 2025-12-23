#!/usr/bin/env bash
# Fetch the latest version of the library
fetch() {
if [ -d "chasm" ]; then return; fi
URL="https://github.com/aqilc/chasm/archive/refs/heads/main.zip"
ZIP="${URL##*/}"
DIR="chasm-main"
mkdir -p .build
cd .build

# Download the release
if [ ! -f "$ZIP" ]; then
  echo "Downloading $ZIP from $URL ..."
  curl -L "$URL" -o "$ZIP"
  echo ""
fi

# Unzip the release
if [ ! -d "$DIR" ]; then
  echo "Unzipping $ZIP to .build/$DIR ..."
  cp "$ZIP" "$ZIP.bak"
  unzip -q "$ZIP"
  rm "$ZIP"
  mv "$ZIP.bak" "$ZIP"
  echo ""
fi
cd ..

# Copy the libs to the package directory
echo "Copying libs to chasm/ ..."
rm -rf chasm
mkdir -p chasm
cp -f ".build/$DIR/asm_x64.h" "chasm/asm_x64.h"
cp -f ".build/$DIR/asm_x64.c" "chasm/asm_x64.c"
echo ""
}


# Test the project
test() {
echo "Running 01-hello-world.c ..."
clang -I. -o 01.exe examples/01-hello-world.c && ./01 && echo -e "\n"
}


# Main script
if [[ "$1" == "test" ]]; then test
elif [[ "$1" == "fetch" ]]; then fetch
else echo "Usage: $0 {fetch|test}"; fi
