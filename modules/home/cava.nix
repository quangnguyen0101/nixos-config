{ pkgs, ... }:
{
  programs.cava = {
    enable = true;
    settings = {
      color = {
        gradient = 0;
        foreground = "cyan";
        background = "default";
      };
    };
  };
}
