{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree
    git
    github-cli
    vim
    wget
    curl
    unzip
    fastfetch
    efibootmgr
    gnumake
    gcc
    nodejs_22
    steam
    sbctl
    usbutils
    brightnessctl # điều khiển backlight laptop (kèm udev rule dựng sẵn)
    ddcutil # điều khiển màn ngoài qua DDC/CI (cần i2c-dev module)
    wlsunset # fallback giảm sáng phần mềm khi màn ngoài không hỗ trợ DDC
  ];
}
