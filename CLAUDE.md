# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A [BlueBuild](https://blue-build.org) project that produces personal bootable container (bootc / rpm-ostree) images layered on Universal Blue's Bluefin. There is no application code: everything is declarative BlueBuild YAML recipes, plus files and scripts that get copied or run inside the image at build time.

Two images are built, each from its own top-level recipe:
- `recipes/bluefin-jf959.yml`: base `ghcr.io/ublue-os/bluefin-dx:stable`
- `recipes/bluefin-dx-nvidia-open-jf959.yml`: base `ghcr.io/ublue-os/bluefin-dx-nvidia-open:stable` (the owner's daily driver)

Images publish to `ghcr.io/jamesfreeman959/<recipe name>` and are signed with cosign (`cosign.pub`; the private key is the `SIGNING_SECRET` repo secret).

## Building

Local build (needs `bluebuild` and podman):
```
./build-image.sh recipes/bluefin-jf959.yml
# equivalent to: bluebuild build --build-driver=podman recipes/bluefin-jf959.yml
```

CI (`.github/workflows/build.yml`) builds both recipes as a matrix with `blue-build/github-action`. It runs daily at 06:00 UTC, on push, on PRs, and on manual dispatch. Pushes that only touch `*.md` or top-level `*.sh` files skip the build. **A new top-level recipe must also be added to the workflow matrix.**

There are no tests or linters. The recipes carry a `yaml-language-server` schema comment (`recipe-v1.json` for top-level recipes, `module-stage-list-v1.json` for feature files), which is the only validation available before a CI build.

## Recipe structure

- Both top-level recipes have the same module list. They differ only in `name`, `description` and `base-image`. Changes meant for both images belong in `recipes/features/`, not in one recipe.
- `recipes/features/bluefin-features.yml` is the shared entry point. It pulls in the other feature files through `from-file:`, in order. Modules run in the order listed, so order matters. For example, `system-files.yml` runs first so that the systemd unit `google-chrome.yml` enables already exists in the image.
- `from-file:` paths are relative to `recipes/`. Paths in `files`, `script` and `gschema-overrides` modules are resolved under `files/`:
  - `files/system/` → copied onto `/` (repo files, systemd units, etc.)
  - `files/scripts/` → build-time scripts used by `type: script` (use `set -oue pipefail`)
  - `files/gschema-overrides/` → GNOME gsettings defaults
  - `files/dconf-bluefin/` → copied to `/etc/dconf/db/distro.d`
- Packages are installed with `dnf` modules. A package from a third-party repo needs that `.repo` file in `files/system/etc/yum.repos.d/`. NetBird is the exception: it uses an `rpm-ostree` module with repo and key URLs.
- Software that installs into `/opt` (a symlink to `/var/opt`, which exists only at runtime) can't be a plain RPM install. Use `optfix:` on the dnf module (as Chrome does) or a `bling` installer that runs at first boot (as 1Password does).

## Gotchas

- The `default-flatpaks` module effectively runs only once per build (see the comment in `features/flatpaks.yml`). The curated list is in `features/flatpaks.yml`, but each top-level recipe also has its own `default-flatpaks` block after `bluefin-features.yml`. Keep this in mind when deciding where a Flatpak change goes.
- `signing` and `files` (system) modules appear both in `features/system-files.yml` and directly in the top-level recipes.
- Parts of `README.md` are inherited from the upstream project (`rrenomeron/ublue-tr`) and are out of date: image names, Starship/Docker claims, and the wallpapers list.
