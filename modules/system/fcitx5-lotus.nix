{ ... }:

{
  services.fcitx5-lotus = {
    enable = true;
    users = [ "sh4d0wph4nt0m" ];
  };

  # Module upstream chỉ set XMODIFIERS, thiếu hai biến này nên app Qt
  # (WPS) và GTK không kết nối được fcitx5 → không gõ được tiếng Việt.
  # /etc/profile source /etc/set-environment nên có hiệu lực cả khi
  # Hyprland khởi động từ TTY.
  environment.variables = {
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
  };
}
