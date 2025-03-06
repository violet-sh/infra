{ pkgs, ... }:
{
  home.shellAliases = {
    cat = "bat -pp";
    less = "bat --style plain --paging always";
    lolcat = "bash -c lolcat"; # Lolcat is currently broken with fish for some reason
    lzg = "lazygit";
    sude = "sudo -E";
  };

  programs = {
    pay-respects.enable = true;
    zoxide.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [
        {
          name = "autopair";
          src = autopair.src;
        }
        {
          name = "colored-man-pages";
          src = colored-man-pages.src;
        }
        {
          name = "done";
          src = done.src;
        }
        {
          name = "grc";
          src = grc.src;
        }
        {
          name = "fifc";
          src = fifc.src;
        }
        {
          name = "fish-bd";
          src = fish-bd.src;
        }
        {
          name = "fish-you-should-use";
          src = fish-you-should-use.src;
        }
        {
          name = "puffer";
          src = puffer.src;
        }
        {
          name = "sponge";
          src = sponge.src;
        }
        {
          name = "sudope";
          src = plugin-sudope.src;
        }
      ];
    };

    starship = {
      enable = true;
      settings = {
        format = "$username@$hostname $directory$git_branch$status> ";
        right_format = "$direnv$jobs";
        add_newline = false;

        username = {
          style_user = "cyan";
          format = "[$user]($style)";
          show_always = true;
        };

        hostname = {
          ssh_only = false;
          format = "[$hostname]($style)";
          style = "blue";
        };

        directory = {
          format = "[$path]($style)[$read_only]($read_only_style)";
          style = "yellow";
          fish_style_pwd_dir_length = 1;
        };

        git_branch = {
          format = " \\($branch(:$remote_branch)\\)";
        };

        status = {
          format = " [\\[]($style)[$status](bold $style)[\\]]($style)";
          style = "red";
          disabled = false;
        };

        direnv = {
          disabled = false;
        };
      };
    };
  };
}
