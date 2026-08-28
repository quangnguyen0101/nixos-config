# Pin antigravity-cli (binary `agy`) to 1.1.22.
#
# nixpkgs-unstable chỉ có 1.0.12, bản này thiếu cờ `--output-format` mà
# modsearch 5.9.1 truyền vào `agy` để làm engine web search keyless (đăng nhập
# Google miễn phí, không cần API key). Thiếu cờ này modsearch báo lỗi
# "flags provided but not defined: -output-format".
#
# Prebuilt tarball được Google phát hành trên GCS; repo GitHub chỉ chứa docs
# (không có flake/source để build). Bump version này mỗi khi modsearch đòi
# bản agy mới hơn.
{ pkgs, ... }:

{
  home.packages = [
    (pkgs.stdenvNoCC.mkDerivation {
      pname = "antigravity-cli";
      version = "1.1.22";

      src = pkgs.fetchurl {
        url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.1.22-5711547746615296/linux-x64/cli_linux_x64.tar.gz";
        hash = "sha256-HhohmobnXXxjUfltGCyiEFMC1cNNj6nDEmXcCt8kFF8=";
      };

      sourceRoot = ".";

      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm755 antigravity $out/bin/agy
        runHook postInstall
      '';

      doInstallCheck = true;
      nativeInstallCheckInputs = [ pkgs.versionCheckHook ];

      meta = {
        mainProgram = "agy";
        version = "1.1.22";
      };
    })
  ];
}
