{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ydotool # giả lập bàn phím cho keep-awake
    btop
    yazi
    neovim
    kdePackages.dolphin
    ghostty
    brave
    brave-search-cli
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
    proton-vpn
    obsidian
    spek
    rmpc
    flac
    jq
    ripgrep
    fd
    lsof
    tailwindcss-language-server
    megasync
    ffmpeg
    cava
    texlive.combined.scheme-full # latexmk, bibtex, biber, latexindent — cho vimtex
    zathura # PDF viewer cho vimtex
    xdotool # forward search Zathura <-> nvim
    tree-sitter # bắt buộc cho nvim-treesitter branch main (yêu cầu CLI >= 0.26.1)
    texstudio # TeX/LaTeX editor
    telegram-desktop
    antigravity
    slack
    easyeffects
    pnpm # dsh cần để quản lý profile plugins
    chromium
    rclone
    wpsoffice
    (pkgs.callPackage ../../pkgs/deepseek-harness { })
    (pkgs.callPackage ../../pkgs/openviking { }) # context database server + CLI
  ];

  # Config fastfetch
  home.file.".config/fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/7.jsonc";
}
