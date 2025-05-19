{
  description = "l3x flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils"; # Utility functions for Nix flakes
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Main Nix package repository

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            cc = "clang";
          };
          overlays = [ 
            rust-overlay.overlays.default
          ];
        };

        rustToolChain = pkgs.rust-bin.nightly.latest.default;
      in {
        packages.default = pkgs.rustPlatform.buildRustPackage rec {
          pname = "l3x";
          version = "2";
          src = pkgs.fetchgit {
            url = "https://github.com/daveman1010221/l3x";
            hash = "sha256-xiOu9GGdvWtFX04w2Rk0ozRw2LO2HE0TQ7akH7J3d7Y=";
          };
          cargoHash = "sha256-tfL33xSZjV9iN40sIK2XQXlF/jSixmUFJRv7V20MGVg=";
          sourceRoot = "${src.name}/l3x";

          RUSTC = "${rustToolChain}/bin/rustc";
          CARGO = "${rustToolChain}/bin/cargo";

          nativeBuildInputs = with pkgs; [
            rustToolChain
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
