{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/zsh.nix
    # ../../modules/home/dms.nix
    ../../modules/home/tmux.nix
    ../../modules/home/nvim.nix
    ../../modules/home/cava.nix
    ../../modules/home/python.nix
    ../../modules/home/ghostty.nix
    # ../../modules/home/noctalia.nix
    ../../modules/home/caelestia.nix
    ../../modules/home/userPackages.nix
    ../../modules/home/rmpc-config/rmpc.nix
  ];

  home.username = "sh4d0wph4nt0m";
  home.homeDirectory = "/home/sh4d0wph4nt0m";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-14 days";
    frequency = "weekly";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/MEGA/Music/";
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

  services.easyeffects = {
    enable = true;
  };

}
