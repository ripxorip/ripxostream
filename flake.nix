{
  description = "Flake for the ripxostream application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nix-formatter-pack
    , flake-utils
    }:

    flake-utils.lib.eachDefaultSystem (system:

    let

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ];
      };

    in
    {

      packages = rec {
        Ripxostream = pkgs.stdenv.mkDerivation rec {
          name = "ripxostream";
          version = "0.0.1";
          src = ./.;
          propagatedBuildInputs = with pkgs; [
            gcc
            meson
            ninja
            pkg-config
            pipewire.dev
          ];
        };
        default = Ripxostream;
      };

      apps = rec {
        ripxostream = flake-utils.lib.mkApp {
          drv = self.packages.${system}.Ripxostream;
          name = "ripxostream";
        };
        default = ripxostream;
      };

      formatter = pkgs.nixpkgs-fmt;
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          gcc
          pkg-config
          meson
          ninja
          pipewire.dev
        ];
      };
    });
}
