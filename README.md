# Zua

Zua is a sample game that tries to replicate a Zelda-like combat system.

## Setup

To run the project, you first need to install Nix.

### Install Nix

```bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

### Enable flakes
After installing Nix, enable flakes by editing your Nix configuration file
(usually `~/.config/nix/nix.conf` or `/etc/nixos/configuration.nix`) and adding:

```conf
experimental-features = nix-command flakes
```

### Run
To run the game:

```bash
nix develop
nixGLIntel love .
```
