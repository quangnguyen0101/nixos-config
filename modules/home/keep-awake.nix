{ pkgs, ... }:

let
  keepAwakeDaemon = pkgs.writeShellScriptBin "keep-awake-daemon" (
    builtins.readFile ./keep-awake/keep-awake-daemon
  );

  keepAwakeMenu = pkgs.writeShellScriptBin "keep-awake" (
    builtins.readFile ./keep-awake/keep-awake
  );
in
{
  home.packages = [ keepAwakeDaemon keepAwakeMenu ];

  systemd.user.services.ydotoold = {
    Unit = {
      Description = "ydotool daemon - giả lập input cho keep-awake";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-path=%t/.ydotool_socket";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.keep-awake = {
    Unit = {
      Description = "keep-awake daemon - giữ máy awake theo yêu cầu";
      After = [ "ydotoold.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${keepAwakeDaemon}/bin/keep-awake-daemon";
      Restart = "no";
    };
  };
}