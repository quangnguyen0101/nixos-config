{ pkgs, lib, ... }:

let
  presets = pkgs.fetchFromGitHub {
    owner = "JackHack96";
    repo = "EasyEffects-Presets";
    rev = "dd966e41ad9e44d4b11e19047f526ba718bbbe57";
    hash = "sha256-JpQVWuEokBRu01xkGA22dPeV5Jo8Xzvfrg5oQ8RtIrI=";
  };

  jsonFiles = lib.filterAttrs (name: _: lib.hasSuffix ".json" name) (builtins.readDir presets);
in
{
  services.easyeffects = {
    enable = true;
  };

  xdg.configFile = lib.mapAttrs' (name: _:
    lib.nameValuePair "easyeffects/output/${name}" {
      source = "${presets}/${name}";
    }
  ) jsonFiles // {
    "easyeffects/irs" = {
      source = "${presets}/irs";
      recursive = true;
    };
  };
}
