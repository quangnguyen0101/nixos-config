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
  ];

  # Config fastfetch
  home.file.".config/fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/7.jsonc";

  # Config opencode
  xdg.configFile."opencode/opencode.jsonc".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "provider": {
        "ollama": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "Ollama",
          "options": {
            "baseURL": "http://localhost:11434/v1"
          },
          "models": {
            "minimax-m2.7:cloud": {
              "name": "MiniMax M2.7"
            },
            "nemotron-3-super:cloud": {
              "name": "Nemotron 3 Super"
            },
            "gpt-oss:120b-cloud": {
              "name": "GPT-OSS 120B"
            },
            "gemma4:31b-cloud": {
              "name": "Gemma 4 31B"
            }
          }
        }
      }
    }
  '';
}
