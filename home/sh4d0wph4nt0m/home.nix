{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/zsh.nix
    # ../../modules/home/dms.nix
    ../../modules/home/tmux.nix
    ../../modules/home/nvim.nix
    ../../modules/home/ghostty.nix
    # ../../modules/home/noctalia.nix
    ../../modules/home/caelestia.nix
    ../../modules/home/userPackages.nix
  ];

  home.username = "sh4d0wph4nt0m";
  home.homeDirectory = "/home/sh4d0wph4nt0m";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/Downloads/Musics/";
    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };

}
