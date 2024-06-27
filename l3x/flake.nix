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
          src = pkgs.fetchgit {
            url = "https://github.com/rmdettmar/l3x";
            rev = "39c3c4e";
            hash = "sha256-XUlrs50XG873tgfRmBXP7C7a8EwKfNCiAjO8pEatCCI=";
          };
          cargoHash = "sha256-nM5SgpfVpnzL3xd3mwgf92MIG023CLlAYPc0+zPQLWk=";
          sourceRoot = "${src.name}/l3x";

          nativeBuildInputs = with pkgs; [
            cacert
            openssl
            openssl.dev
            pkg-config
          ];
          buildInputs = with pkgs; [
            cacert
            openssl
            openssl.dev
            pkg-config
          ];

          pathsToLink = [
            "/bin"
            "/etc/ssl/certs"
          ];

          RUSTFLAGS = [
            "-C" "link-arg=-L${pkgs.openssl.dev}/lib"
            "-C" "link-arg=-lssl"
            "-C" "link-arg=-lcrypto"
          ];
          
          shellHook = ''
            echo "PREBUILD"
            export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
            export SSL_CERT_DIR="/etc/ssl/certs"
            export CARGO_HTTP_CAINFO="/etc/ssl/certs/ca-bundle.crt"
            export OPENSSL_DIR="${pkgs.openssl.dev}"
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
            export OPENSSL_LIBS="${pkgs.openssl.dev}/lib"
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