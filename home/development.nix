{ pkgs, ... }:

{
  programs = {
    bun.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };

  home.packages = with pkgs; [
    # C/C++
    cmake
    libgcc
    mold
    ninja
    rocmPackages.llvm.clang

    # Nix
    nil

    # Rust
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
    rust-analyzer

    # JavaScript
    deno
    nodejs
    pnpm

    # Python
    python3
  ];

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=--ld-path=mold"]
  '';
}
