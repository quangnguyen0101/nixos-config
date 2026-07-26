{ pkgs, ... }:
{
  programs.rmpc = {
    enable = true;
    config = builtins.readFile ./config.ron;
  };

  xdg.configFile."rmpc/themes/nord.ron".source = ./themes/nord.ron;
}
