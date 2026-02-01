{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      jdt-language-server
      tree-sitter
    ];

    plugins = with pkgs.vimPlugins; [
      # Common
      catppuccin-nvim
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      cmp-treesitter
      comment-nvim
      delimitMate
      {
        plugin = fidget-nvim;
        config = ''
          packadd! fidget.nvim
          lua << END
            require("fidget").setup()
          END
        '';
      }
      indent-blankline-nvim
      lspsaga-nvim
      {
        plugin = lsp_signature-nvim;
        config = ''
          packadd! lsp_signature.nvim
          lua << END
            require("lsp_signature").setup()
          END
        '';
      }
      {
        plugin = lualine-nvim;
        config = ''
          lua << END
            require("lualine").setup()
          END
        '';
      }
      null-ls-nvim
      nvim-autopairs
      {
        plugin = nvim-cmp;
        config = ''
          packadd! nvim-cmp
          lua << END
            require("cmp").setup {
              sources = {
                { name = "buffer" },
                { name = "cmdline" },
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "treesitter" },
              }
            }
          END
        '';
      }
      nvim-lspconfig
      {
        plugin = nvim-tree-lua;
        config = ''
          packadd! nvim-tree.lua
          lua << END
            require("nvim-tree").setup()
          END
        '';
      }
      nvim-treesitter.withAllGrammars
      rainbow-delimiters-nvim
      undotree

      # Languages
      crates-nvim
      elixir-tools-nvim
      {
        plugin = go-nvim;
        config = ''
          packadd! go.nvim
          lua << END
           require("go").setup()
          END
        '';
      }
      glow-nvim
      jedi-vim
      nvim-jdtls
      nvim-ts-autotag
      render-markdown-nvim
      rustaceanvim
      typescript-tools-nvim
      vim-elixir
      vim-nix
    ];

    extraConfig = ''
      colorscheme catppuccin-macchiato
    '';
  };

  catppuccin.nvim.enable = false; # Doesn't load plugin correctly
}
