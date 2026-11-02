{ config, pkgs, lib, ... }:

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
    extraPortals = lib.mkForce [ pkgs.xdg-desktop-portal-gtk ];
  };

  # No display manager → Hyprland tự launch từ tty → graphical-session.target không được
  # start → portal chính fail khi D-Bus activation ("startup job failed").
  # Portal implementation chỉ cần dbus, không cần graphical-session.target.
  systemd.user.services.xdg-desktop-portal = {
    after = lib.mkForce [ "dbus.service" ];
    partOf = lib.mkForce [ ];
  };
  systemd.user.services.xdg-document-portal = {
    partOf = lib.mkForce [ ];
  };
  systemd.user.services.xdg-desktop-portal-rewrite-launchers = {
    partOf = lib.mkForce [ ];
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
