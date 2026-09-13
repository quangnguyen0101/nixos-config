{ config, pkgs, ... }:

let
  jupyterEnv = pkgs.python3.withPackages (p: [
    p.jupyterlab
    p.jupyter-collaboration # realtime autosave — jupyter-mcp-server cần để phát hiện thay đổi
    p.ipykernel
    p.pandas
    p.numpy
    p.matplotlib
    p.scipy
    p.scikit-learn
  ]);
in
{
  # JupyterLab cho data science — MCP server (opencode) connect tới 127.0.0.1:8888
  # qua JUPYTER_URL/JUPYTER_TOKEN (xem modules/home/opencode.nix).
  home.packages = [ jupyterEnv ];

  systemd.user.services.jupyterlab = {
    Unit = {
      Description = "JupyterLab server (data science, 127.0.0.1:8888)";
    };

    Service = {
      # ip=127.0.0.1: không lộ ra ngoài; token cố định khớp với JUPYTER_TOKEN trong MCP
      ExecStart = "${jupyterEnv}/bin/jupyter lab --no-browser --ip=127.0.0.1 --port=8888 --IdentityProvider.token=jupylocal-ds";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}