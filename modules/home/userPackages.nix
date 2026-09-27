{ config, pkgs, ... }:

let
  # WPS 11.1.0.11723 bundle Qt 5.12.10 (2018) va chi kem platform plugin xcb
  # (khong co libqwayland.so). WPS tu hardcode QT_QPA_PLATFORM=wayland khi thay
  # session Wayland -> crash "Could not find the Qt platform plugin wayland",
  # va bin/wps chay "> /dev/null 2>&1" nen nuot het stderr.
  # Giu DISPLAY=:0 (XWayland) + che bien session Wayland de WPS fallback xcb.
  # Bọc ca 5 entry point vi wps/et/wpp/wpspdf deu hardcode giong nhau.
  wps = name:
    pkgs.writeShellScriptBin name ''
      unset WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_SESSION_DESKTOP
      export XDG_SESSION_TYPE=x11
      exec ${pkgs.wpsoffice}/bin/${name} "$@"
    '';
in
{
  home.packages = with pkgs; [
    ydotool # giả lập bàn phím cho keep-awake
    p7zip
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
    texliveFull # latexmk, bibtex, biber, latexindent — cho vimtex (top-level scheme; combined deprecated)
    zathura # PDF viewer cho vimtex
    xdotool # forward search Zathura <-> nvim
    tree-sitter # bắt buộc cho nvim-treesitter branch main (yêu cầu CLI >= 0.26.1)
    texstudio # TeX/LaTeX editor
    telegram-desktop
    antigravity-ide # renamed tu antigravity
    slack
    easyeffects
    pnpm # PM Node.js tổng dụng
    uv # tool Python tổng dụng (uv/uvx)
    defuddle # HTML->markdown CLI, runtime cho obsidian-skills/defuddle
    chromium
    rclone
    (wps "wpsoffice")
    (wps "wps")
    (wps "et")
    (wps "wpp")
    (wps "wpspdf")
    poppler-utils # pdftotext/pdfinfo
    (pkgs.tesseract5.override { enableLanguages = [ "eng" "vie" ]; }) # OCR eng+vie, fallback cho vision
    impression
    drawio # ERD/Chen diagrams, UML
    cmake # C/C++ build system
    gcc # C/C++ compiler (cc = gcc)
    (pkgs.callPackage ../../pkgs/openviking { }) # context database server + CLI
  ];

  # Config fastfetch
  home.file.".config/fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/7.jsonc";
}
