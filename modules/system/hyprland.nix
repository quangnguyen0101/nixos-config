{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Essential polkit agent
  security.polkit.enable = true;

  # XDG Desktop Portal intergration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # GTK themes using dconf
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop.interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono 11";
      };
    }
  ];
}
