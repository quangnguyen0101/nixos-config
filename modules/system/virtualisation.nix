{ pkgs, ... }:

# VM KVM/QEMU cho Ubuntu và Windows, quản lý bằng virt-manager (GUI).
# Host đã có VT-x + /dev/kvm nên guest chạy gần native; RAM/disk chỉ tốn
# khi VM đang bật. Ảnh VM nằm ở /var/lib/libvirt/images (cùng ổ với /).

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # qemu_kvm chỉ emulate đúng kiến trúc host (x86_64) — nhẹ hơn `pkgs.qemu`
      # (bản đầy đủ kèm aarch64/riscv...). Đủ dùng cho Ubuntu + Windows.
      package = pkgs.qemu_kvm;

      # TPM 2.0 ảo — Windows 11 bắt buộc (Ubuntu không cần nhưng không hại).
      swtpm.enable = true;

      # virtiofsd cho shared folder giữa host ↔ guest (virt-manager:
      # Add Hardware → Filesystem → Driver: virtiofs).
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  # Chia sẻ USB (điện thoại, YubiKey, đầu đọc thẻ...) vào guest qua SPICE.
  virtualisation.spiceUSBRedirection.enable = true;

  # virt-manager + tự autoconnect qemu:///system.
  programs.virt-manager.enable = true;

  # libvirt NAT (dnsmasq trên virbr0) phục vụ DHCP/DNS cho guest. Firewall
  # NixOS mặc định DROP ở INPUT nên phải trust interface này, nếu không guest
  # lấy được IP nhưng không resolve được DNS.
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Không có group này thì virt-manager chỉ xem được, không tạo/sửa VM
  # (polkit rule của libvirtd cho phép group `libvirtd`).
  users.users.sh4d0wph4nt0m.extraGroups = [ "libvirtd" ];

  # libvirt chỉ copy default NAT network (virbr0) vào /var/lib, không tự bật.
  # Bật + autostart để guest có mạng ngay sau boot, không phải `virsh` tay.
  systemd.services.libvirt-default-network = {
    description = "Start libvirt default NAT network";
    wantedBy = [ "multi-user.target" ];
    wants = [ "libvirtd.service" ];
    after = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.libvirt}/bin/virsh net-autostart default || true
      ${pkgs.libvirt}/bin/virsh net-start default || true
    '';
  };
}
