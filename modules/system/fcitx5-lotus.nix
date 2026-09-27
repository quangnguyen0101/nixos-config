{ ... }:

{
  services.fcitx5-lotus = {
    enable = true;
    users = [ "sh4d0wph4nt0m" ];
  };

  # Module upstream chỉ set XMODIFIERS, thiếu QT_IM_MODULE nên app Qt
  # (WPS) không kết nối được fcitx5 → không gõ được tiếng Việt.
  # /etc/profile source /etc/set-environment nên có hiệu lực cả khi
  # Hyprland khởi động từ TTY.
  #
  # KHÔNG set GTK_IM_MODULE: GTK3/4 trên Wayland tự dùng text-input-v3,
  # set var này ép GTK về im module kiểu cũ (fcitx sẽ cảnh báo).
  # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
  environment.variables = {
    QT_IM_MODULE = "fcitx";
  };
}
