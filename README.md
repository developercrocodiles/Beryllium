# Beryllium

Beryllium is an opinionated Fedora Bootc image with Hyprland and DankMaterialShell (DMS), configured for container-focused development and everyday use.

## Installation

### ISOs

Download an ISO for your hardware:

- x86_64
  - [AMD/Intel](https://isos.zirconium.gay/zirconium-isos/beryllium-amd64.iso) ([checksum](https://isos.zirconium.gay/zirconium-isos/beryllium-amd64.iso-CHECKSUM))
  - [NVIDIA](https://isos.zirconium.gay/zirconium-isos/beryllium-nvidia-amd64.iso) ([checksum](https://isos.zirconium.gay/zirconium-isos/beryllium-nvidia-amd64.iso-CHECKSUM))
- ARM64
  - [AMD/Intel](https://isos.zirconium.gay/zirconium-isos/beryllium-arm64.iso) ([checksum](https://isos.zirconium.gay/zirconium-isos/beryllium-arm64.iso-CHECKSUM))
  - [NVIDIA](https://isos.zirconium.gay/zirconium-isos/beryllium-nvidia-arm64.iso) ([checksum](https://isos.zirconium.gay/zirconium-isos/beryllium-nvidia-arm64.iso-CHECKSUM))

### Rebase

From an existing Fedora Atomic or Bootc installation, run:

```bash
sudo bootc switch ghcr.io/zirconium-dev/beryllium:latest
```

For NVIDIA systems:

```bash
sudo bootc switch ghcr.io/zirconium-dev/beryllium-nvidia:latest
```

The gaming-focused Jackrabbit images are available as `beryllium-jackrabbit` and `beryllium-jackrabbit-nvidia`. Jackrabbit currently has no install ISO; install Beryllium first, then rebase to the desired image.

The NVIDIA kernel module and OGC kernel used in Jackrabbit are not currently signed, so Secure Boot is unavailable for those images. See [the related issue](https://github.com/zirconium-dev/zirconium/issues/108).

## Configuration

DMS deploys its Hyprland configuration during initial setup. Run `dms setup` to deploy or refresh DMS-managed defaults; place personal Hyprland configuration in the supported user config files alongside the generated DMS includes.
