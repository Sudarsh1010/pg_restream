{
  description = "Development shell for pg_restream";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, rust-overlay, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          rust-bin.stable."1.100.0".default
          rustPlatform.bindgenHook
          pkg-config
          gnumake
          bison
          flex
        ];

        buildInputs = with pkgs; [
          libedit
          zlib
        ];
      };
    };
}
