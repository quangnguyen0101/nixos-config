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
    embedding.dense = {
      provider = "ollama";
      api_base = "http://127.0.0.1:11434/v1";
      model = "nomic-embed-text";
      dimension = 768;
    };
    vlm = {
      provider = "litellm";
      api_key = "ollama";
      model = "ollama/nemotron-3-super:cloud";
      api_base = "http://127.0.0.1:11434";
      max_retries = 3;
      extra_request_body.think = false;
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
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.sessionVariables.OPENVIKING_URL = "http://127.0.0.1:1933";
}
