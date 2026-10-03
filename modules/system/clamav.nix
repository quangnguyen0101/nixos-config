{ ... }:

{
  # NixOS khong co module cho clamav, va freshclam/clamsan hardcode doc
  # /etc/clamav/freshclam.conf (strace xac nhan clamscan mo dung path nay).
  # Dat config o day thay vi o ~, de moi lenh deu chay khong can flag:
  #   freshclam                      -> cap nhat DB
  #   clamscan -r <duong-dan>        -> quet
  #
  # DatabaseDirectory phai tro sang thu muc ghi duoc: DB dir compile-time
  # cua ClamAV nam trong /nix/store (read-only) nen -d la bat buoc neu
  # khong co config nay.
  environment.etc."clamav/freshclam.conf".text = ''
    DatabaseDirectory /home/sh4d0wph4nt0m/.local/share/clamav
    UpdateLogFile /home/sh4d0wph4nt0m/.local/share/clamav/freshclam.log
    LogTime yes
    DatabaseMirror database.clamav.net
    DatabaseMirror db.local.clamav.net
  '';

  # KHONG dat "NotifyClamd no" trong file nay: freshclam parse nham "no"
  # thanh ten file roi error. Mac dinh (co clamd) thi chay exit 0.
}