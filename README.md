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
    │   └── modules/home/         (user-level: zsh, tmux, nvim, ghostty, packages)
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
| **AI** | Ollama (local), CodeCompanion, Minuet, Opencode |
| **Gaming** | Steam with 32-bit support |
| **Fonts** | JetBrains Mono, Fira Code, Hack, 0xProto Nerd Fonts |

## Structure

- **`hosts/`** – per-machine NixOS config (hostname, hardware, system imports)
- **`home/`** – Home Manager user config (shell, editor, terminal, packages)
- **`modules/system/`** – reusable NixOS modules (Hyprland, fonts, networking, bluetooth, i18n, GC, Steam, greeter)
- **`modules/home/`** – reusable Home Manager modules (zsh, tmux, nvim, ghostty, caelestia, user packages)
- **`flake.nix`** – entry point that ties everything together
