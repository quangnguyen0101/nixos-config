{ config, pkgs, ... }:

{
  # Cần i2c-dev module để ddcutil truy cập DDC/CI của màn ngoài
  boot.kernelModules = [ "i2c-dev" ];

  # Tạo group `video` (thường đã có sẵn, đảm bảo tồn tại)
  users.groups.video = { };

  # Udev rules:
  #  - cấp quyền ghi brightness backlight cho group `video` (không cần sudo)
  #  - cho phép group `video` truy cập /dev/i2c-* (DDC/CI của ddcutil)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="i2c-dev", MODE="0660", GROUP="video"
  '';

  # Thêm user chính vào group `video`
  users.users.sh4d0wph4nt0m.extraGroups = [ "video" ];
}
