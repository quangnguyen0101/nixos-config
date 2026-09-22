{ config, pkgs, ... }:

let
  # jupyter-collaboration 4.4.0 có test-suite fail với jupyter-server-ydoc trong
  # nixpkgs (UndoManager.__init__() got an unexpected keyword argument 'doc' —
  # upstream incompatibility). Runtime vẫn chạy tốt, chỉ skip check phase.
  jupyter-collaboration = pkgs.python314Packages.jupyter-collaboration.overridePythonAttrs (old: {
    doCheck = false;
  });

  jupyterPython = pkgs.python314.override {
    packageOverrides = self: super: {
      inherit jupyter-collaboration;
    };
  };

  # Single python env (python314) — gồm cả các gói từ python.nix (pip, requests,
  # mutagen): tránh ngay buildEnv conflict khi home.packages có hai python env
  # cùng install lib/pkgconfig/python3.pc.
  jupyterEnv = jupyterPython.withPackages (p: [
    p.jupyterlab
    p.jupyter-collaboration # realtime autosave — jupyter-mcp-server cần để phát hiện thay đổi
    p.ipykernel
    p.pip
    p.numpy
    p.requests
    p.pandas
    p.mutagen
    p.matplotlib
    p.scipy
    p.scikit-learn
    p.jinja2 # latex-document-skill mail_merge.py (deps python duoc cung cap boi env python duy nhat nay)
    p.trafilatura # lấy nội dung bài báo/trang web -> markdown (CLI: trafilatura --URL)
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