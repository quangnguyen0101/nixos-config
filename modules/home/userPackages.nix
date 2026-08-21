{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    yazi
    neovim
    kdePackages.dolphin
    ghostty
    brave
    brave-search-cli
    opencode
    tmux
    wl-clipboard
    cliphist
    vlc
    zsh
    oh-my-zsh
    fastfetch
    vscode
    ollama
    qimgv
    bibata-cursors
    rnote
    hyprmon
    proton-vpn
    obsidian
    spek
    rmpc
    flac
    jq
    megasync
    ffmpeg
    cava
    telegram-desktop
    antigravity
    slack
    easyeffects
    (pkgs.callPackage ../../pkgs/deepseek-harness { })
  ];

  # Config fastfetch
  home.file.".config/fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/7.jsonc";

  # Config opencode - TUI
  xdg.configFile."opencode/tui.json".text = ''
    {
      "$schema": "https://opencode.ai/tui.json",
      "display_thinking": true
    }
  '';

  # Config opencode
  xdg.configFile."opencode/opencode.jsonc".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "attachment": {
        "image": {
          "auto_resize": true,
          "max_width": 1024,
          "max_height": 1024,
          "max_base64_bytes": 2097152
        }
      },
      "provider": {
        "ollama": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "Ollama",
          "options": {
            "baseURL": "http://localhost:11434/v1"
          },
          "models": {
            "minimax-m2.7:cloud": {
              "name": "MiniMax M2.7",
              "modalities": {
                "input": ["text", "image"],
                "output": ["text"]
              }
            },
            "nemotron-3-super:cloud": {
              "name": "Nemotron 3 Super",
              "modalities": {
                "input": ["text", "image"],
                "output": ["text"]
              }
            },
            "gpt-oss:120b-cloud": {
              "name": "GPT-OSS 120B",
              "modalities": {
                "input": ["text", "image"],
                "output": ["text"]
              }
            },
            "gemma4:31b-cloud": {
              "name": "Gemma 4 31B",
              "modalities": {
                "input": ["text", "image"],
                "output": ["text"]
              }
            }
          }
        }
      }
    }
  '';
}
