{ pkgs, ... }:

# Declarative Postgres container cho data science workspace.
# Chạy qua virtualisation.oci-containers (docker backend) — container được
# tạo/quản lý bởi Nix, không phải docker run thủ công.

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.postgres-ds = {
      image = "postgres:17-alpine";
      autoStart = true;
      ports = [ "127.0.0.1:5432:5432" ];
      environment = {
        POSTGRES_USER = "dsuser";
        POSTGRES_PASSWORD = "dssecret";
        POSTGRES_DB = "datascience";
      };
      volumes = [
        "/home/sh4d0wph4nt0m/data/postgres:/var/lib/postgresql/data"
      ];
    };
  };
}