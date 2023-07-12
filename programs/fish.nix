{ pkgs, config, ... }:

let nixPath = config.nix.nixPath;
in {
  enable = true;
  interactiveShellInit = ''
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    _pure_set_default pure_show_prefix_root_prompt true
  '';
  loginShellInit = ''
    set -p fish_function_path $HOME/.config/fish/functions ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d
    set -e __HM_SESS_VARS_SOURCED
    set -e fish_function_path[1]
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    end
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    end
    if test -e /etc/static/fish/config.fish
      source /etc/static/fish/config.fish
    end
    set -e fish_function_path[1]
    set -e NIX_PATH
    set -x NIX_PATH ${
      builtins.concatStringsSep " " nixPath
    } $HOME/.nix-defexpr/channels
  '';
  shellAliases = rec {
    vim = "nvim";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    ls = "ls";
    ll = "${ls} -lh";
    la = "${ls} -a";
    lla = "${ls} -lha";
    lt = "${ls} --tree";

    cdot = "cd ~/dotfiles";
    nix-opt = "nix-store --optimise";
  };
  functions = {
    workon = {
      argumentNames = "project";
      description = "Go to the given project";
      body = ''
        set --local prev_dir (pwd)
        set --local projects_dirs ~/projects
        for proj_dir in $projects_dirs
          if test -d $proj_dir/$project
            set --local project_dir $proj_dir/$project
            cd $project_dir
            if test -d ~/.pyenv/version/$project
              pyenv activate $project
            end
            if test -f $project_dir/shell.nix
              nix-shell
            end
            function __on_exit --on-event fish_exit --inherit-variable prev_dir
              cd $prev_dir
            end
            return 0
          end
        end
        echo "Project $project not found"
        return 1
      '';
    };
    nix-prune = {
      body =
        "nix-env --delete-generations old --profile /nix/var/nix/profiles/system; nix-collect-garbage -d";
    };
    local-psql = {
      argumentNames = "action";
      description = "Start or stop local PostgreSQL instance";
      body = ''
        env PGPORT=5432 pg_ctl -D /usr/local/var/postgres -l /tmp/logfile $action > /dev/null 2>&1
      '';
    };
  };
  plugins = [
    rec {
      name = "pure";
      src = pkgs.fetchFromGitHub {
        owner = "rafaelrinaldi";
        repo = name;
        rev = "69e9a074125ad853aae244ce2aabc33811b99970";
        sha256 = "1x1h65l8582p7h7w5986sc9vfd7b88a7hsi68dbikm090gz8nlxx";
      };
    }
    rec {
      name = "pisces";
      src = pkgs.fetchFromGitHub {
        owner = "laughedelic";
        repo = name;
        rev = "34971b9671e217cfba0c71964f5028d44b58be8c";
        sha256 = "05wjq7v0v5hciqa27wx2xypyywa4291pxmmvfv5yvwmxm1pc02hm";
      };
    }
  ];
}
