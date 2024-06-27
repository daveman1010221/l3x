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
          version = "f671735";
          src = pkgs.fetchgit {
            url = "https://github.com/rmdettmar/l3x";
            rev = "39c3c4e";
            hash = "sha256-XUlrs50XG873tgfRmBXP7C7a8EwKfNCiAjO8pEatCCI=";
          };
          cargoHash = "sha256-nM5SgpfVpnzL3xd3mwgf92MIG023CLlAYPc0+zPQLWk=";
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