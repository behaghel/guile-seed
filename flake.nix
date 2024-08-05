{
  description = "A flake for getting started with Guile.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    supportedSystems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (
      system: let
        pkgs = import nixpkgs{
          inherit system;
        };

        makeShell = p:
          p.mkShell {
            buildInputs = with p; [
              guile
            ];
          };
      in {
        devShells = {
          default = makeShell pkgs;
        };

        formatter = pkgs.default.alejandra;
      }
    );
}
