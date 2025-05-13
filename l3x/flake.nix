{
  description = "l3x flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils"; # Utility functions for Nix flakes
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Main Nix package repository
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
          version = "2";
          src = pkgs.fetchgit {
            url = "https://github.com/daveman1010221/l3x";
            hash = "sha256-Ryn8a9MVTx8sgJ9vBdSnQgy5P5uOW7kRv5I1wm7cpwI=";
          };
          cargoHash = "sha256-h5io2B9QQr0AWe1ps2fQAs6jgpFvy+/E0lIdVnGI9ns=";
          sourceRoot = "${src.name}/l3x";

          nativeBuildInputs = with pkgs; [
            openssl
            openssl.dev
            pkg-config
          ];
          buildInputs = with pkgs; [
            openssl
            openssl.dev
            pkg-config
          ];
        };
      }
    );
}
