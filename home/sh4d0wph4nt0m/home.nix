{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/zsh.nix
    ../../modules/home/tmux.nix
    ../../modules/home/nvim.nix
    ../../modules/home/ghostty.nix
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

  home.hyprdynamicmonitors = {
    enable = true;
  };
}
