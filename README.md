# Beryllium

Beryllium is an opinionated Fedora Bootc image with Hyprland and DankMaterialShell (DMS), configured for container-focused development and everyday use.

## Installation

### ISOs

Download an ISO for your hardware:

ISO files are comeing soon.

### Rebase

From an existing Fedora Atomic or Bootc installation, run:

```bash
sudo bootc switch ghcr.io/developercrocodiles/beryllium:latest
```

For NVIDIA systems:

```bash
sudo bootc switch ghcr.io/developercrocodiles/beryllium-nvidia:latest
```

The gaming-focused Jackrabbit images are available as `beryllium-jackrabbit` and `beryllium-jackrabbit-nvidia`. Jackrabbit currently has no install ISO; install Beryllium first, then rebase to the desired image.

The NVIDIA kernel module and OGC kernel used in Jackrabbit are not currently signed, so Secure Boot is unavailable for those images. See [the related issue](https://github.com/zirconium-dev/zirconium/issues/108).

## Configuration

DMS deploys its Hyprland configuration during initial setup. Run `dms setup` to deploy or refresh DMS-managed defaults; place personal Hyprland configuration in the supported user config files alongside the generated DMS includes.
