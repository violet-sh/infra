{ pkgs, ... }:
{
  programs = {
    bun.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk25;
    };
  };

  home.packages = with pkgs; [
    # C/C++
    cmake
    gnumake
    libgcc
    mold
    ninja
    pkg-config
    rocmPackages.clang

    # Containers
    firecracker
    firectl
    kraft
    qemu

    # BEAM
    elixir
    erlang
    erlang-language-platform
    glas
    gleam
    next-ls

    # JavaScript
    deno
    nodejs
    pnpm
    yarn

    # Nix
    nil
    nixd

    # Prolog
    swi-prolog-gui

    # Python
    python3
    uv

    # Rust
    (rust-bin.selectLatestNightlyWith (
      toolchain: toolchain.default.override { extensions = [ "rust-src" ]; }
    ))
    rust-analyzer
  ];

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=--ld-path=mold"]
  '';
}
