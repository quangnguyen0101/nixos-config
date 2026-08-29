{ config, pkgs, ... }:

{
  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "Mount Google Drive via rclone";
    };
    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount "Google Drive:" %h/GoogleDrive \
          --vfs-cache-mode full \
          --vfs-cache-max-size 30G \
          --vfs-cache-max-age 24h \
          --dir-cache-time 1000h \
          --poll-interval 15s \
          --drive-acknowledge-abuse \
          --log-level INFO
      '';
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -uz %h/GoogleDrive";
      Restart = "on-failure";
      RestartSec = "10";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}