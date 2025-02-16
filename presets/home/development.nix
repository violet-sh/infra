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

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        astro-build.astro-vscode
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        denoland.vscode-deno
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        svelte.svelte-vscode
        tamasfe.even-better-toml
        vadimcn.vscode-lldb
        vscjava.vscode-java-pack
      ];
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
    rocmPackages.llvm.clang
    rocmPackages.llvm.clang-tools-extra

    # Nix
    nil

    # Rust
    (rust-bin.selectLatestNightlyWith (
      toolchain:
      toolchain.default.override {
        extensions = [ "rust-src" ];
      }
    ))
    rust-analyzer

    # JavaScript
    bun
    deno
    nodejs
    pnpm
    yarn

    # Python
    python3
  ];

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=--ld-path=mold"]
  '';
}
