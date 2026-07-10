{ pkgs, inputs, ... }:
{
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.system}.default;
    systemd.enable = true; # chạy như systemd user service

    settings = {
      plugins.colorSchemes = {
        predefinedScheme = "Catppuccin";
        darkMode = true;
      };
      bar = {
        position = "top";
        barType = "simple";
        widgets.left = [
          {
            type = "Clock";
            settings.format = "HH:mm";
          }
        ];
        widgets.center = [
          { type = "Workspace"; }
        ];
        widgets.right = [
          { type = "Tray"; }
          { type = "Volume"; }
          { type = "Battery"; }
        ];
      };
    };
  };
}
