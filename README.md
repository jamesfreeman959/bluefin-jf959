# bluefin-jf959 &nbsp; [![bluebuild build badge](https://github.com/jamesfreeman959/bluefin-jf959/actions/workflows/build.yml/badge.svg)](https://github.com/jamesfreeman959/bluefin-jf959/actions/workflows/build.yml)

These are [Bootable Container](https://containers.github.io/bootable/) images built from [Universal Blue](https://universal-blue.org) base images with [BlueBuild](https://bulue-build.org)'s tools. The images contain the [Bluefin](https://projectbluefin.io) operating system with with my personal preferences baked in.  The image based on Bluefin DX (``bluefin-dx-nvidia-open``) is my daily driver.

Inspiration taken from https://github.com/rrenomeron/ublue-tr/ with thanks!

Modifications common to both images:

- Google Chrome RPM installed and set as default browser
- [Variety](https://peterlevi.com/variety/) wallpaper changer (installed as RPM for now)
- Clocks set to AM/PM view with Weekday Display
- Curated selection of Flatpak apps installed automatically at runtime (this overrides Bluefin's
  default flatpak choices)
- Single click to open items in Nautilus
- Use smaller icons in Nautilus icon view
- Sort directories first in Nautilus and GTK file choosers
- Dark styles enabled by default
- [System76 wallpaper collection](https://system76.com/merch/desktop-wallpapers)
- Historical Ubuntu wallpapers, mostly from the LTS versions
- [Intel One Mono](https://www.intel.com/content/www/us/en/company-overview/one-monospace-font.html) set as default monospace font


For the Bluefin Images (``ghcr.io/rrenomeron/bluefin-dx-tr``):

- Starship disabled by default (users can enable if needed)
- Rootful Docker disabled.  Users can set up 
  [rootless Docker](https://docs.docker.com/engine/security/rootless/) for themselves.
- A different list of default flatpaks

## Which Image? Which Version?

Bluefin (see 
[Bluefin's docs](https://docs.projectbluefin.io/administration#upgrades-and-throttle-settings)
for more details):

- ``ghcr.io/rrenomeron/bluefin-dx-nvidia-open:stable`` -- Bluefin Stable with developer tools and nVidia drivers, updated
  weekly

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/jamesfreeman959/bluefin-jf959:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/jamesfreeman959/bluefin-jf959:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/jamesfreeman959/bluefin-jf959
```
