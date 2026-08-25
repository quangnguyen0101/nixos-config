# Quản lý plugins của dsh profile "web" một cách declarative.
#
# Manifests (package.json, pnpm-lock.yaml, pnpm-workspace.yaml) được vendor trong
# ./dsh-profile/ và đồng bộ vào ~/.dsh/profiles/web bằng activation script:
# chỉ chạy `pnpm install --frozen-lockfile` khi hash manifests thay đổi.
#
# Thư mục profile vẫn writable: plugin cài lẻ qua Plugin Market sẽ sống đến lần
# rebuild kế tiếp mà manifests khai báo thay đổi (lúc đó bị reset về bộ khai báo).
#
# Workflow thêm plugin declaratively:
#   1. cd modules/home/dsh-profile
#   2. Sửa package.json: thêm vào "dependencies" VÀ mảng "dsh".profile."bundles"
#   3. Cập nhật lockfile:  nix shell nixpkgs#pnpm -c pnpm install --lockfile-only
#   4. nixos-rebuild switch
{
  lib,
  pkgs,
  ...
}:

let
  manifestHash = builtins.hashString "sha256" (
    builtins.hashFile "sha256" ./dsh-profile/package.json
    + builtins.hashFile "sha256" ./dsh-profile/pnpm-lock.yaml
    + builtins.hashFile "sha256" ./dsh-profile/pnpm-workspace.yaml
  );
in

{
  # Lưu ý: uv (runtime cho bundle dsh-ouroboros) khai báo trong userPackages.nix.
  # uv resolve python >=3.12 từ python3 sẵn có trên PATH của user.
  #
  # SSL_CERT_FILE: Python bundled của plugin dsh-vision-toolkit không kèm CA store;
  # NixOS giữ CA bundle hệ thống tại đây. Bắt buộc cho mọi HTTPS từ Python subprocess.
  home.sessionVariables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
  # VISION_SSL_VERIFY: Plugin spawn Python subprocess với CUSTOM env, chỉ truyền
  # vars mà visionEnv() liệt kê — SSL_CERT_FILE từ parent KHÔNG đến được subprocess.
  # Biến này được visionEnv() đọc từ process.env và forward sang subprocess,
  # nơi Python kiểm tra và tắt cert verify (vision_client.py:_ssl_context).
  # Free service vision.anionex.me không cần TLS verify.
  home.sessionVariables.VISION_SSL_VERIFY = "false";

  home.activation.dshPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    (
      target="$HOME/.dsh/profiles/web"
      marker="$target/.nix-manifest-hash"
      declared="${manifestHash}"
      current=""
      [ -f "$marker" ] && current="$(cat "$marker")"
      # User patch layer đồng bộ ngoài guard hash: thay đổi patch không cần
      # chạy lại pnpm install, chỉ cần restart dsh.
      install -m 644 ${./dsh-profile/cordis.patch.yml} "$target/cordis.patch.yml"
      if [ "$declared" != "$current" ]; then
        printf 'Syncing declarative dsh plugins -> %s\n' "$target"
        mkdir -p "$target"
        install -m 644 ${./dsh-profile/package.json} "$target/package.json"
        install -m 644 ${./dsh-profile/pnpm-lock.yaml} "$target/pnpm-lock.yaml"
        install -m 644 ${./dsh-profile/pnpm-workspace.yaml} "$target/pnpm-workspace.yaml"
        # Toolchain cho native module build (node-pty/cpu-features/ssh2):
        # node cho lifecycle scripts + node-gyp cần gcc/make/python3 và Node
        # headers khớp ABI của dsh runtime.
        # pnpm 11 đọc config qua tiền tố pnpm_config_* (không còn npm_config_*).
        export PATH="${pkgs.nodejs}/bin:${pkgs.gcc}/bin:${pkgs.gnumake}/bin:${pkgs.python3}/bin:$PATH"
        export pnpm_config_nodedir="${pkgs.nodejs}"
        export npm_config_nodedir="${pkgs.nodejs}"
        ${lib.getExe pkgs.pnpm} install --dir "$target" --frozen-lockfile --prefer-offline
        echo "$declared" > "$marker"
      fi
    )
  '';
}
