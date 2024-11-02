{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    catppuccin.enable = false; # Doesn't load plugin correctly

    extraPackages = with pkgs; [
      jdt-language-server
      tree-sitter
    ];

    plugins = with pkgs.vimPlugins; [
      # Common
      catppuccin-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-treesitter
      comment-nvim
      delimitMate
      fidget-nvim
      indent-blankline-nvim
      lsp_signature-nvim
      lspsaga-nvim
      null-ls-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-cmp
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      rainbow-delimiters-nvim
      undotree

      # Languages
      crates-nvim
      glow-nvim
      jedi-vim
      nvim-jdtls
      nvim-ts-autotag
      rustaceanvim
      typescript-tools-nvim
      vim-nix
    ];

    extraConfig = ''
      colorscheme catppuccin-macchiato
    '';
  };
}
