{
  description = "Flake to manage elixir project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # see https://ejpcmac.net/blog/using-nix-in-elixir-projects/

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # elixir = pkgs.elixir;
        # elixir = pkgs.beam.packages.elixir;
        elixir = pkgs.beam.packages.erlangR26.elixir_1_15;

      in {
        devShell = pkgs.mkShell {
          packages = [
            elixir
          ];
          buildInputs = []
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            # For ExUnit Notifier on Linux.
            pkgs.libnotify

            # For file_system on Linux.
            pkgs.inotify-tools
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin ([
            # For ExUnit Notifier on macOS.
            pkgs.terminal-notifier

            # For file_system on macOS.
            pkgs.darwin.apple_sdk.frameworks.CoreFoundation
            pkgs.darwin.apple_sdk.frameworks.CoreServices
          ]);

          shellHook = ''
            echo "ELIXIR: $(elixir --short-version)"
          '';
        };
      });
}
