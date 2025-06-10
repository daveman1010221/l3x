{
  description = "l3x flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { flake-utils, nixpkgs, rust-overlay, ... }:
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
          packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "l3x";
          version = "0.1.0";

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          sourceRoot = "l3x";

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
