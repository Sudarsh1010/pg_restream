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
          (rust-bin.stable."1.100.0".default.override {
            extensions = [
              "rust-src"
              "rust-analyzer"
            ];
          })
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

        shellHook = ''
          # pgrx 0.20.1 rejects Nix's reproducibility seed when generating C macros.
          # Keep the rest of the bindgen flags, including Clang's include paths.
          export BINDGEN_EXTRA_CLANG_ARGS="$(printf '%s\n' "$BINDGEN_EXTRA_CLANG_ARGS" | sed -E 's/(^|[[:space:]])-frandom-seed=[^[:space:]]+/\1/g')"
        '';
      };
    };
}
