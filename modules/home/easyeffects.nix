{ pkgs, lib, ... }:

let
  jackhack96 = pkgs.fetchFromGitHub {
    owner = "JackHack96";
    repo = "EasyEffects-Presets";
    rev = "dd966e41ad9e44d4b11e19047f526ba718bbbe57";
    hash = "sha256-JpQVWuEokBRu01xkGA22dPeV5Jo8Xzvfrg5oQ8RtIrI=";
  };

  digitalone1 = pkgs.fetchFromGitHub {
    owner = "Digitalone1";
    repo = "EasyEffects-Presets";
    rev = "6fc0630f3d18f5668b11ebe4846179914b0bd24e";
    hash = "sha256-MQ72Tg4YAlzsRrQtVOUxaQKNmbxUjaci+FAr2MvjrEQ=";
  };

  jsonFiles = name: src:
    lib.filterAttrs (n: _: lib.hasSuffix ".json" n) (builtins.readDir src);

  allJsonFiles = (jsonFiles "jackhack96" jackhack96) // (jsonFiles "digitalone1" digitalone1);

  mkPresetLink = src: name: _:
    lib.nameValuePair "easyeffects/output/${name}" {
      source = "${src}/${name}";
    };

  jackhack96Links = lib.mapAttrs' (mkPresetLink jackhack96) (jsonFiles "jackhack96" jackhack96);
  digitalone1Links = lib.mapAttrs' (mkPresetLink digitalone1) (jsonFiles "digitalone1" digitalone1);
in
{
  services.easyeffects = {
    enable = true;
  };

  systemd.user.services.easyeffects = {
    Unit = {
      After = lib.mkForce [ "default.target" ];
      PartOf = lib.mkForce [ "default.target" ];
    };
    Install.WantedBy = lib.mkForce [ "default.target" ];
  };

  xdg.dataFile = jackhack96Links // digitalone1Links // {
    "easyeffects/irs" = {
      source = "${jackhack96}/irs";
      recursive = true;
    };
  };
}
