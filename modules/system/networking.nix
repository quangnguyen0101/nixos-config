{ config, pkgs, ... }:

{

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager = {
    enable = true;
    # NM không tự cấp DNS từ DHCP — dùng cứng Google DNS (tránh ISP DNS pollution
    # làm Steam/website bị chặn ở tầng DNS).
    dns = "none";
  };
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  networking.firewall.enable = true;
}
