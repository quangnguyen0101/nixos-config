{ pkgs, ... }:

{
  # ===== In ấn =====
  services.printing = {
    enable = true;
    drivers = [
      pkgs.epson-escpr
    ];
  };

  # # ===== Scan =====
  # hardware.sane = {
  #   enable = true;
  #   extraBackends = [ pkgs.epkowa ];
  # };
  #
  # environment.systemPackages = with pkgs; [
  #   sane-frontends # cung cấp lệnh `scanimage` (CLI) + `xscanimage`
  #   simple-scan # GUI đơn giản, dễ dùng hàng ngày
  #   xsane # GUI nâng cao hơn, nhiều tùy chỉnh (crop, DPI, mode màu...)

}
