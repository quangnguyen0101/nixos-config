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
  home.activation.dshPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    (
      target="$HOME/.dsh/profiles/web"
      marker="$target/.nix-manifest-hash"
      declared="${manifestHash}"
      current=""
      [ -f "$marker" ] && current="$(cat "$marker")"
      if [ "$declared" != "$current" ]; then
        printf 'Syncing declarative dsh plugins -> %s\n' "$target"
        mkdir -p "$target"
        install -m 644 ${./dsh-profile/package.json} "$target/package.json"
        install -m 644 ${./dsh-profile/pnpm-lock.yaml} "$target/pnpm-lock.yaml"
        install -m 644 ${./dsh-profile/pnpm-workspace.yaml} "$target/pnpm-workspace.yaml"
        ${lib.getExe pkgs.pnpm} install --dir "$target" --frozen-lockfile --prefer-offline
        echo "$declared" > "$marker"
      fi
    )
  '';
}
