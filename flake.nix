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
      rev = if (lib.hasAttrByPath [ "rev" ] self.sourceInfo) then self.sourceInfo.rev else "Dirty Build";

      overlays = [
        self.overlays.default
        nixd.overlays.default
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
    } // utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      devShell = pkgs.mkShell {
        # buildInputs = with pkgs; [ lefthook nixpkgs-fmt inputs.agenix.packages.${system}.agenix ];
      };
    });
}
