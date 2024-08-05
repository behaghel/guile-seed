{
  description = "A Nix-flake-based Guile development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
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
        pkgs = import nixpkgs {
          inherit system;
        };

        makeShell = p:
          p.mkShell {
            buildInputs = with p; [
              guile
            ];
            shellHook = ''
                ${pkgs.guile}/bin/guile --version
            '';
          };
      in {
        devShells = {
          default = makeShell pkgs;
        };

        formatter = pkgs.default.alejandra;
      }
    );
}