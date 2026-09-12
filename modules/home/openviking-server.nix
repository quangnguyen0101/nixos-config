{
  config,
  lib,
  pkgs,
  ...
}:

let
  openviking = pkgs.callPackage ../../pkgs/openviking { };
  ovHome = "${config.home.homeDirectory}/.openviking";
in
{
  home.file.".openviking/ov.conf".text = builtins.toJSON {
    storage = {
      workspace = "${ovHome}/data";
      vectordb = {
        name = "context";
        backend = "local";
      };
      agfs.backend = "local";
    };
    embedding = {
      allow_metadata_override = true;
      dense = {
        provider = "litellm";
        model = "gemini/gemini-embedding-2";
        dimension = 768;
      };
    };
    vlm = {
      provider = "litellm";
      model = "gemini/gemini-3.6-flash";
      max_retries = 3;
    };
  };

  home.file.".openviking/ovcli.settings.conf".text = builtins.toJSON {
    language = "en";
  };

  systemd.user.services.openviking-server = {
    Unit = {
      Description = "OpenViking context database server";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      ExecStart = "${openviking}/bin/openviking-server --host 127.0.0.1 --port 1933";
      Environment = [ "HOME=%h" ];
      EnvironmentFile = [ "%h/.openviking/gemini.env" ];
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.sessionVariables.OPENVIKING_URL = "http://127.0.0.1:1933";
}
