#!/usr/bin/bash

set -eou pipefail

echo "Installing Bluefin wallpapers from ublue-os/artwork..."

mkdir -p /usr/share/backgrounds/bluefin
mkdir -p /usr/share/gnome-background-properties

# Download wallpaper images (JXL) and day/night slideshow XMLs
echo "Downloading wallpaper images..."
IMAGE_LIST=$(curl -s "https://api.github.com/repos/ublue-os/artwork/contents/wallpapers/bluefin/images" | \
    jq -r '.[] | .download_url')

for url in ${IMAGE_LIST}; do
    filename=$(basename "${url}" | cut -d'?' -f1)
    echo "  ${filename}"
    curl -sL -o "/usr/share/backgrounds/bluefin/${filename}" "${url}"
done

# Download GNOME background properties XMLs (registers wallpapers in the picker)
echo "Downloading GNOME background properties..."
PROPS_LIST=$(curl -s "https://api.github.com/repos/ublue-os/artwork/contents/wallpapers/bluefin/gnome-background-properties" | \
    jq -r '.[] | .download_url')

for url in ${PROPS_LIST}; do
    filename=$(basename "${url}" | cut -d'?' -f1)
    echo "  ${filename}"
    curl -sL -o "/usr/share/gnome-background-properties/${filename}" "${url}"
done

echo "Bluefin wallpapers installed successfully"
