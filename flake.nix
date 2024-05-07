{
  description = "ragons infra mew";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-master
    , ...
    }:
    let
      lib = nixpkgs.lib;
      rev = if (lib.hasAttrByPath [ "rev" ] self.sourceInfo) then self.sourceInfo.rev else "Dirty Build";

      overlays = [
      ];
      genPkgsWithOverlays = system: import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      nixosSystem = system: extraModules: hostName:
        let
          pkgs = genPkgsWithOverlays system;
        in
        nixpkgs.lib.nixosSystem
          rec {
            inherit system;
            specialArgs = { inherit lib inputs; };
            modules = [
              ./nixos-common.nix
              {
                networking.hostName = hostName;
              }
            ] ++ extraModules;
          };

      processConfigurations = lib.mapAttrs (n: v: v n);


    in
    {
      lib = lib.my;
      overlays.default = final: prev: {
        unstable = import nixpkgs-master {
          system = prev.system;
          config.allowUnfree = true;
        };
      };

      nixosConfigurations = processConfigurations {
        picard = nixosSystem "x86_64-linux" [ ./nixos-hosts/picard/default.nix ];
        ds9 = nixosSystem "x86_64-linux" [ ./nixos-hosts/ds9/default.nix ];
      };
    };
}
