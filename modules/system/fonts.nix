{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # font có icon, cần cho bar/terminal hiện đại
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts._0xproto
    noto-fonts # font cơ bản, hiển thị đa ngôn ngữ
    noto-fonts-cjk-sans # tiếng Trung/Nhật/Hàn nếu cần
    noto-fonts-color-emoji # emoji 🎉
    # Các font phổ biến hay dùng hằng ngày
    carlito # metric-compatible Calibri (tài liệu Word)
    caladea # metric-compatible Cambria (tài liệu Word)
    ubuntu-classic # hệ font Ubuntu
    inter # UI font hiện đại
    roboto # font Android/Material
    open-sans # font web phổ biến
    dejavu_fonts # font base cổ điển
    font-awesome # icons app/bar
    material-icons # icons Material
  ];

  fonts.fontconfig.enable = true;
  # Chọn font mặc định cho cả hệ thống (fallback khi app không chỉ định)
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Inter" "Noto Sans" ];
    serif = [ "DejaVu Serif" "Noto Serif" ];
    monospace = [ "JetBrainsMono Nerd Font" ];
  };
}
