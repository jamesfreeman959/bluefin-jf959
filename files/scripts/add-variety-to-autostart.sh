#!/usr/bin/bash

set -eou pipefail

if [ ! -d /etc/skel/.config/autostart/ ]; then
	mkdir -p /etc/skel/.config/autostart/
fi

cp /usr/share/applications/variety.desktop /etc/skel/.config/autostart/
