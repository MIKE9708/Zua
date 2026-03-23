{
  description = "A Shell for Lua and Love development";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = {nixpkgs, nixgl, ...} : let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [nixgl.overlay];
    };

    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [pkgs.lua pkgs.love pkgs.nixgl.nixGLIntel];
      };
    };
}
