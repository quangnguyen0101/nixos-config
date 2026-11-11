---
tags: [nixos, vm, libvirt, qemu]
---

# VM — Ubuntu & Windows trên NixOS (KVM + virt-manager)

> [!info] Cài gì
> Module `modules/system/virtualisation.nix` bật `libvirtd` (QEMU/KVM), `virt-manager`,
> TPM 2.0 ảo (`swtpm`), OVMF/UEFI (có sẵn trong qemu của nixpkgs), chia sẻ USB (SPICE)
> và `virtiofsd` cho shared folder. Không chạy daemon nền nặng — RAM/disk chỉ tốn khi VM bật.

Host hiện tại: i7-9850H (VT-x, `/dev/kvm` OK), 15G RAM, ~106G trống trên `/`.

## 1. Sau khi rebuild

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw
# logout/login (hoặc reboot) để nhận group libvirtd
virt-manager
```

Kiểm tra nhanh:

```bash
virsh -c qemu:///system net-list      # default  active  yes
ls -l /dev/kvm                         # crw-rw-rw- ... kvm
```

## 2. Tạo VM Ubuntu (dev/test)

1. Tải ISO: https://ubuntu.com/download/desktop (bản LTS mới nhất, ~6G).
2. `virt-manager` → **Create a new virtual machine** → *Local install media (ISO)* → chọn ISO.
3. Bỏ tick **"Automatically detect from the installation media"** → chọn **Ubuntu 24.04/26.04 LTS** (hoặc để trống, installer tự chạy).
4. RAM **4096 MB**, CPU **4**, disk **40 GB** (qcow2).
5. Đặt tên `ubuntu-dev` → **Finish**, cài như máy thật.

Sau khi cài, vào **VM → Details**:

| Mục | Nên chỉnh |
|-----|-----------|
| CPUs → Topology | `copy host CPU configuration` (nhanh nhất) |
| Video | **Virtio** (guest Linux hỗ trợ sẵn) |
| Display | **Spice** + tick *OpenGL* nếu cần |
| NIC | model **virtio** (mặc định đã đúng) |

## 3. Tạo VM Windows 11

Windows 11 cần **UEFI + Secure Boot + TPM 2.0** — module đã bật sẵn TPM, OVMF có sẵn trong qemu.

1. Tải ISO Windows 11 từ Microsoft (hoặc dùng Media Creation Tool trên máy khác).
2. Tải **virtio-win.iso** (driver ổ đĩa/mạng cho Windows):

   ```bash
   sudo curl -L -o /var/lib/libvirt/images/virtio-win.iso \
     https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
   ```

3. `virt-manager` → New VM → ISO Windows → RAM **6144–8192 MB**, CPU **4**, disk **64 GB**.
4. **Trước khi bấm Finish**, tick **"Customize configuration before install"**:
   - **Overview → Firmware**: chọn `UEFI x86_64: .../OVMF_CODE_4M.ms.fd` (bản `.ms` = Secure Boot).
   - **Add Hardware → TPM → Type: Emulated, Version 2.0**.
   - **Add Hardware → Storage → Device type: CDROM → chọn `virtio-win.iso`**.
   - (tuỳ chọn) **Add Hardware → Filesystem → Driver: virtiofs** để share thư mục host.
5. Trong Windows Setup, ở bước chọn ổ đĩa: **Load driver → CD virtio-win → `amd64\w11`** → chọn
   `viostor` (ổ đĩa) và `NetKVM` (mạng), sau đó ổ 64G sẽ hiện ra.
6. Cài xong, mở `virtio-win.iso` trong Windows và chạy `virtio-win-guest-tools.exe` để có
   driver đầy đủ (balloon, qemu-ga, shared folder).

> [!tip] Windows không cần Secure Boot?
> Nếu gặp trục trặc, dùng `OVMF_CODE_4M.fd` (không `.ms`) + tắt Secure Boot trong
> *Overview → Firmware*. TPM 2.0 vẫn phải bật.

## 4. Tài nguyên gợi ý (host 15G RAM)

| VM | RAM | vCPU | Disk |
|----|----:|-----:|-----:|
| Ubuntu dev (chạy 1 mình) | 4096–6144 MB | 4 | 40G |
| Ubuntu + Chrome/Docker trong VM | 8192 MB | 6 | 60G |
| Windows 11 (Office, tool nội bộ) | 6144–8192 MB | 4–6 | 64G |

Đừng chạy Ubuntu 8G và Windows 8G cùng lúc — host sẽ swap. Disk là **qcow2** nên file
`.qcow2` chỉ phình dần theo dữ liệu thật.

## 5. Thao tác thường dùng

```bash
virsh -c qemu:///system list --all        # VM + trạng thái
virsh -c qemu:///system start ubuntu-dev
virsh -c qemu:///system shutdown ubuntu-dev
virsh -c qemu:///system snapshot-list ubuntu-dev
virsh -c qemu:///system snapshot-create-as ubuntu-dev clean "trước khi cài bậy"
virsh -c qemu:///system snapshot-revert ubuntu-dev clean
```

Snapshot trong virt-manager: **VM → Snapshots → +**. Nhớ tắt VM trước khi snapshot
(hoặc chấp nhận snapshot "live" có thể không nhất quán).

### Shared folder (host ↔ guest)

- Guest Linux: Add Hardware → Filesystem → Driver `virtiofs`, Source path `~/shared`,
  Target `shared` → trong guest `sudo mount -t virtiofs shared /mnt/shared`.
- Guest Windows: cần `virtio-win-guest-tools` + service **VirtIO-FS** (chạy sau khi cài driver).

### USB passthrough

VM đang chạy → **Virtual Machine → Redirect USB device** (nhờ `spiceUSBRedirection`).
Điện thoại/YubiKey cắm vào là thấy.

## 6. Gỡ / tắt

- Tắt hẳn: comment `../../modules/system/virtualisation.nix` trong
  `hosts/nixos-btw/configuration.nix` rồi rebuild. Ảnh VM ở `/var/lib/libvirt/images`
  vẫn còn — xoá tay nếu không dùng.
- Gỡ một VM: `virsh -c qemu:///system undefine --remove-all-storage <tên>`.

## 7. Lỗi thường gặp

| Triệu chứng | Xử lý |
|-------------|-------|
| virt-manager báo "Authentication required" / không tạo được VM | Chưa có group `libvirtd` trong session — logout/login lại, kiểm tra `groups` |
| Guest không có mạng | `virsh net-list` phải thấy `default active`; nếu không: `virsh net-start default` |
| `KVM is not available` | `ls /dev/kvm`; kiểm tra `boot.kernelModules` có `kvm-intel` (đã có trong hardware-config) |
| Windows Setup không thấy ổ đĩa | Chưa Load driver `viostor` từ `virtio-win.iso` (mục `amd64\w11`) |
| Windows 11 báo "PC không đáp ứng yêu cầu" | Firmware phải là UEFI (`.ms.fd`), TPM 2.0 bật, RAM ≥ 4G, disk ≥ 64G |
| VM chậm / giật hình | Video = Virtio (Linux) hoặc QXL + Spice (Windows); bật `copy host CPU`; đừng để host swap |

> [!note] IPv6
> Host tắt IPv6 (`networking.enableIPv6 = false`) — NAT của libvirt dùng IPv4 nên không ảnh hưởng.
