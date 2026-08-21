{
  lib,
  stdenv,
  buildNpmPackage,
  fetchurl,
  runCommand,
  makeWrapper,
  nodejs,
}:

let
  version = "0.1.0-rc.7";

  # Tarball gốc từ npm registry
  upstream = fetchurl {
    url = "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-${version}.tgz";
    hash = "sha512-ZceDCJ8FAywih+USW/OMk9jEhunlvJBGEz4kqrhau23hPzbciOazZrywH0nBRsaalSeAJ1JGBmjtw4OSjToStw==";
  };

  # Vá manifest TRƯỚC khi build: mọi peerDependencies trong cây được nâng thành
  # dependencies trực tiếp của root, vì dsh import chúng lúc runtime nhưng
  # --legacy-peer-deps không cài peers. Vá sẵn vào src để cả fetchNpmDeps lẫn
  # install phase nhìn thấy cùng một lockfile.
  src = runCommand "deepseek-harness-${version}-patched-src" { inherit upstream; } ''
    mkdir -p $out
    tar xzf $upstream -C $out --strip-components=1
    cp ${./package.json} $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in

buildNpmPackage rec {
  pname = "deepseek-harness";
  inherit version src;

  # Lockfile sinh với --legacy-peer-deps (cây peer của các package dsh-* quá phức tạp)
  npmFlags = [ "--legacy-peer-deps" ];

  npmDepsHash = "sha256-OydAWcqYNXIjy3n+LneOVNDRACl/MpXcx3Zo9B04R3s=";

  inherit nodejs;

  dontNpmBuild = true; # dist đã được build sẵn trong tarball npm

  # cordis-plugin-hmr yêu cầu node chạy với --expose-internals
  postInstall = ''
    rm $out/bin/dsh
    makeWrapper ${nodejs}/bin/node $out/bin/dsh \
      --add-flags "--expose-internals" \
      --add-flags "$out/lib/node_modules/@deepseek-ai/dsh/lib/bin.js"
  '';

  meta = {
    description = "DeepSeek Harness agent CLI (dsh): everything is a plugin";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.mit;
    mainProgram = "dsh";
    platforms = lib.platforms.linux;
  };
}
