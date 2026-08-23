{
  python3Packages,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  ps = python3Packages.override {
    overrides =
      final: prev: {
        "openviking-sdk" =
          final.callPackage ./deps/openviking-sdk.nix
            { ps = final; inherit stdenv fetchurl autoPatchelfHook; };
        volcengine =
          final.callPackage ./deps/volcengine.nix
            { ps = final; inherit fetchurl; };
        "volcengine-python-sdk" =
          final.callPackage ./deps/volcengine-python-sdk.nix
            { ps = final; inherit fetchurl; };
        "opentelemetry-instrumentation-asyncio" =
          final.callPackage ./deps/opentelemetry-instrumentation-asyncio.nix
            { ps = final; inherit fetchurl; };
        "tree-sitter-language-pack" =
          final.callPackage ./deps/tree-sitter-language-pack.nix
            { ps = final; inherit stdenv fetchurl autoPatchelfHook; };
      };
  };
in
ps.callPackage ./package.nix { inherit ps stdenv fetchurl autoPatchelfHook; }
