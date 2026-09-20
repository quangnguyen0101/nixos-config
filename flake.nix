{
  description = "NixOS configuration";

  inputs.self.submodules = true; # submodule in self flake

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia = {
    #   url = "github:noctalia-dev/noctalia/legacy-v4";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # dms = {
    #   url = "github:AvengeMedia/DankMaterialShell/stable";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fcitx5-lotus = {
      url = "github:LotusInputMethod/fcitx5-lotus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
      fcitx5-lotus,
      llm-agents,
      # noctalia,
      ...
    }:
    {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-btw/configuration.nix

          fcitx5-lotus.nixosModules.fcitx5-lotus

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.sh4d0wph4nt0m = ./home/sh4d0wph4nt0m/home.nix;
            # home-manager.sharedModules = [
            #   noctalia.homeModules.default
            # ];
          }

          # Overlay: autoskills (midudev/autoskills, CC-BY-NC-4.0 — branch
          # off in pkgs/opencode/autoskills; tarball trong store, khong vendor
          # noi dung skill vao repo). Dung qua `pkgs.autoskills`.
          ({ pkgs, lib, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                autoskills = final.callPackage ./pkgs/opencode/autoskills { };
              })
            ];
          })

          lanzaboote.nixosModules.lanzaboote
          ({ pkgs, lib, ... }: {
            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.
#boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/var/lib/sbctl";
            };
          })
        ];
      };
    };
}
