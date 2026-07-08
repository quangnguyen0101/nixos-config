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
  ];
}
