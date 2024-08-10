{
  description = "A flake for getting started with Guile.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system:
      import nixpkgs { inherit system; overlays = [ self.overlay ]; }
    );
  in {
    # A Nixpkgs overlay.
    overlay = final: prev: {
      guile-hall = final.callPackage ./guile-hall.nix {};
    };
    # Provide some binary packages for selected system types.
    packages = forAllSystems (system:
      {
        inherit (nixpkgsFor.${system}) hello;
      });
    devShells = forAllSystems (system: with nixpkgsFor.${system};
      {
        default =  mkShell {
          buildInputs = [
            guile
            # guix
            # is required by guile-hall but guix itself
            # requires guix-daemon and all sorts of setup that's out
            # of reach from this flake.
            # Therefore to use `hall` command, we assume you are in an
            # environment with a a working `guix` installation.
            guile-hall
          ];
        };
      });
    formatter = forAllSystems(system:
      self.packages.${system}.default.alejandra
    );
    templates = rec {
      basic = {
        path = ./templates/basic;
        description = "A getting started template for a new Guile project";
      };
      default = basic;
    };
  };
}
