#!/usr/bin/bash

# This is a convenience script for building images locally.

# Usage: ./build-image.sh <recipe.yml>
# Example: ./build-image.sh recipes/bluefin-jf959.yml
# Requires bluebuild to be installed

# Check if a valid recipe file was provided as an argument
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: $0 <recipe.yml>"
    exit 1
fi

if [ $(command -v bluebuild) ]; then
    bluebuild build --build-driver=podman $1
else 
    echo "Bluebuild not installed, can't build!"
    exit 1
fi