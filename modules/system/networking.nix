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

  # Viettel chặn Steam store o tang IP, khong phai tang DNS: store.steampowered.com
  # giai ra 23.15.142.182 (Akamai edge cua VN) — TCP/443 ket noi duoc nhung TLS
  # ClientHello bi drop -> curl timeout. Steamcommunity/api/google van binh
  # thuong, nen khong phai chan SNI hay chan ca Steam.
  #
  # Do do doi DNS o tren vo dung. Chi con tro sang edge Akamai khac la vao duoc
  # (da verify: HTTP 200, <title>Welcome to Steam, 1.2MB HTML, co search+cart).
  #
  # IP hardcode la fragile: Akamai lai lai IP edge, het hieu luc la can verify
  # lai bang lenh ben duoi roi sua IP nay.
  # nixpkgs 26.11: extraHosts la string (noi bang \n), khong con la list-of-attrs.
  networking.extraHosts = ''
    23.15.140.216 store.steampowered.com
  '';

  networking.firewall.enable = true;
}
