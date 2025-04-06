{
  description = "Flake for basham";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, flake-utils, ... } @ inputs:
  flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      inherit system;
    };
  in {
    packages.basham = import ./. { inherit pkgs; };
    packages.default = self.packages.${system}.basham;
  });
}
