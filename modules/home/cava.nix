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

  # Ghi đè thẳng, không tạo .hm-backup (file backup cũ bị clobber làm activation fail)
  xdg.configFile."cava/config".force = true;
}
