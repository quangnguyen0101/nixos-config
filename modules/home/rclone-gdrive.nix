{ config, pkgs, ... }:

let
  mountScript = pkgs.writeShellScriptBin "rclone-mount" ''
    set -eu

    mount_point="''${HOME}/GoogleDrive"

    if ${pkgs.util-linux}/bin/mountpoint -q "''${mount_point}" 2>/dev/null; then
      exit 0
    fi

    ${pkgs.coreutils}/bin/mkdir -p "''${mount_point}"

    exec ${pkgs.rclone}/bin/rclone mount "GDrive:" "''${mount_point}" \
      --vfs-cache-mode full \
      --vfs-cache-max-size 30G \
      --vfs-cache-max-age 24h \
      --dir-cache-time 1000h \
      --poll-interval 15s \
      --drive-acknowledge-abuse \
      --log-level INFO
  '';
in
{
  home.packages = [ mountScript ];

  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "Mount Google Drive via rclone";
    };
    Service = {
      Type = "simple";
      ExecStart = "${mountScript}/bin/rclone-mount";
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -uz %h/GoogleDrive";
      Restart = "on-failure";
      RestartSec = "10";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}