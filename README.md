# nixos-config

Personal NixOS + Home Manager flake configuration for `x86_64-linux`.

## Overview

Single-host setup managed via a **Nix flake** with **Home Manager** integration. The config is modular, split into system-level and user-level modules.

```
flake.nix
└── nixosConfigurations.nixos-btw
    ├── hosts/nixos-btw/          (host-specific: hardware, networking, locale)
    ├── modules/system/           (system-level: hyprland, fonts, steam, bluetooth, etc.)
    ├── home-manager → home/
    │   └── modules/home/         (user-level: zsh, tmux, nvim, ghostty, opencode, packages)
    ├── pkgs/                     (custom packages: deepseek-harness)
    └── lanzaboote                (secure boot)
```

## Key Components

| Category | Tools |
|---|---|
| **WM** | Hyprland + Caelestia shell |
| **Shell** | Zsh + Oh-My-Zsh |
| **Terminal** | Ghostty (Catppuccin) |
| **Editor** | Neovim with 30+ plugins (LSP, DAP, formatters, AI) |
| **Multiplexer** | Tmux + resurrect/continuum |
| **Login** | greetd + regreet (Rosé Pine) |
| **Input** | fcitx5 + bamboo (Vietnamese) |
| **AI** | Opencode (declarative config) + Ollama (user service, cloud models), CodeCompanion, Minuet |
| **Gaming** | Steam with 32-bit support |
| **Fonts** | JetBrains Mono, Fira Code, Hack, 0xProto Nerd Fonts |

## Structure

- **`hosts/`** – per-machine NixOS config (hostname, hardware, system imports)
- **`home/`** – Home Manager user config (shell, editor, terminal, packages)
- **`modules/system/`** – reusable NixOS modules (Hyprland, fonts, networking, bluetooth, i18n, GC, Steam, greeter)
- **`modules/home/`** – reusable Home Manager modules (zsh, tmux, nvim, ghostty, caelestia, user packages)
  - **`opencode.nix`** – opencode config (`programs.opencode.settings`) + `ollama.service` systemd **user** service
- **`pkgs/`** – custom packages built with `callPackage`
- **`flake.nix`** – entry point that ties everything together

## Rebuild

```sh
sudo nixos-rebuild switch --flake .#nixos-btw
```

## AI Stack

- **Opencode**: config fully declarative via home-manager's `programs.opencode`
  - Provider: Ollama (`http://localhost:11434/v1`) with cloud models — see `modules/home/opencode.nix`
  - TUI settings in `programs.opencode.tui` → `~/.config/opencode/tui.json`
- **Ollama**: runs as a systemd *user* service (auto-start on login) so it uses the user's `~/.ollama` cloud auth

```sh
systemctl --user status ollama   # check service
ollama list                      # list available models
```

> When adding/removing a model: update `programs.opencode.settings.provider.ollama.models`, then rebuild.
> Remember to restart opencode after rebuild — config is only loaded at startup.
