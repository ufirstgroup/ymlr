{
  description = "Flake to manage elixir project";

  inputs = {
    # see https://zero-to-nix.com/concepts/flakes

    # nixpkgs-unstable
    # nixpkgs.url = "nixpkgs";

    # when something is broken in nixpkgs-unstable we can try to find a known good commit ...
    nixpkgs.url = "nixpkgs/f8e2ebd66d097614d51a56a755450d4ae1632df1";
    # ... or fallback to latest nixos- stable
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    # ... or maybe a certain version
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.*.tar.gz";
    # (which should be the same as)
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils";
  };

  # see https://ejpcmac.net/blog/using-nix-in-elixir-projects/

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # elixir = pkgs.elixir;
        # elixir = pkgs.beam.packages.elixir;
        elixir = pkgs.beam.packages.erlangR26.elixir_1_16;

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
