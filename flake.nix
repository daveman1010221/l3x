{
  description = "l3x flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils"; # Utility functions for Nix flakes
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Main Nix package repository
    # localSrc = {
    #     url = "path:./l3x";
    # };
  };

  outputs = { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
      };
      in {
        packages.default = pkgs.rustPlatform.buildRustPackage rec {
          pname = "l3x";
          version = "f671735";
        #   src = pkgs.fetchgit {
        #     url = "https://github.com/VulnPlanet/l3x";
        #     rev = "f671735";
        #     hash = "sha256-H+gKdJxO/kXEVofQa9WJLRj1DcbxdzQfUvRotpKPQFU=";
        #   };
          src = ./l3x;
          cargoHash = "";
          # sourceRoot = "${src.name}";

          nativeBuildInputs = [
            pkgs.rustPlatform.cargoBuildHook
          ];
          
          preHook = ''
            echo "PREBUILD"
          '';

          # buildPhase = ''
          #   # echo ${src.name}
          #   echo "REBECCA"
          #   # echo "aAAAa"
          #   # if [! -f Cargo.lock ]; then
          #   #   echo "Cargo.lock not found"
          #   #   cargo generate-lockfile
          #   # fi
          #   # cargo build --release
          # '';
        };
      }
    );
}