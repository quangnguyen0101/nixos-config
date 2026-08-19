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
      "disabled_providers": ["ollama"]
    }
  '';
}
