#!/usr/bin/bash

set -eou pipefail

echo "Installing Bluefin wallpapers from ublue-os/artwork..."

# Get the download URL for the latest bluefin GNOME wallpapers release
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/ublue-os/artwork/releases" | \
    jq -r '[.[] | select(.tag_name | startswith("bluefin-v"))][0].assets[] | select(.name == "bluefin-wallpapers-gnome.tar.zstd") | .browser_download_url')

if [ -z "${DOWNLOAD_URL}" ]; then
    echo "ERROR: Could not find bluefin-wallpapers-gnome.tar.zstd in releases"
    exit 1
fi

echo "Downloading from: ${DOWNLOAD_URL}"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

curl -L -o "${TMPDIR}/bluefin-wallpapers-gnome.tar.zstd" "${DOWNLOAD_URL}"
zstd -d "${TMPDIR}/bluefin-wallpapers-gnome.tar.zstd" -o "${TMPDIR}/bluefin-wallpapers-gnome.tar"
tar -x -f "${TMPDIR}/bluefin-wallpapers-gnome.tar" -C "${TMPDIR}"

mkdir -p /usr/share/backgrounds/bluefin
mkdir -p /usr/share/gnome-background-properties

# JXL images and day/night XML slide show files go into the backgrounds directory
find "${TMPDIR}" -maxdepth 1 \( -name "*.jxl" -o -name "*.xml" \) -exec cp {} /usr/share/backgrounds/bluefin/ \;

# GNOME background properties XMLs register wallpapers with the GNOME picker
cp "${TMPDIR}/gnome-background-properties/"*.xml /usr/share/gnome-background-properties/

echo "Bluefin wallpapers installed successfully"
