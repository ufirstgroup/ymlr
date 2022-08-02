{
  description = "Flake to manage elixir project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          packages = [
            pkgs.elixir
          ];
          shellHook = ''
            echo "ELIXIR: $(elixir --short-version)"
          '';
        };
      });
}
