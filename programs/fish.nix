{pkgs, ...}: {
  enable = true;
  interactiveShellInit = ''
    # pure's own conf.d runs before this file and already sets the variable, and
    # _pure_set_default only fills in unset ones -- so it has to be set directly.
    set -g pure_show_prefix_root_prompt true

    set -g fish_greeting
  '';
  loginShellInit = ''
    # Only spawn a standalone ssh-agent when there isn't already a working
    # agent socket. On stout the gpg-agent (enableSshSupport) provides it, and
    # on macOS launchd does, so this avoids clobbering SSH_AUTH_SOCK and
    # leaking a fresh agent on every login shell.
    if not test -S "$SSH_AUTH_SOCK"
      eval (ssh-agent -c)
    end
  '';
  shellAliases = rec {
    vim = "nvim";
    vi = "nvim";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    ls = "ls";
    ll = "${ls} -lh";
    la = "${ls} -a";
    lla = "${ls} -lha";
    lt = "${ls} --tree";

    cdot = "cd ~/dotfiles";
    nix-shell = "nix-shell --command fish";
    claudio = "ANTHROPIC_BASE_URL=http://127.0.0.1:8001 ANTHROPIC_MODEL=unsloth/Qwen3.5-9B-GGUF claude --strict-mcp-config --mcp-config ~/.claude/no-mcp.json";
  };
  functions = {
    nix = {
      argumentNames = "cmd";
      description = "Override Nix commands";
      body = ''
        if test $cmd = "develop"
          command nix develop --command fish
        else
          command nix $argv
        end
      '';
    };
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
            else if test -f $project_dir/flake.nix
              nix develop
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
    games = {
      description = "Pick an installed Steam game with fzf and launch it";
      body = ''
        set --local libraries $HOME/.local/share/Steam/steamapps
        set --local vdf $libraries/libraryfolders.vdf
        if test -f $vdf
          for path in (string match --regex --groups-only '^\s*"path"\s+"(.*)"$' < $vdf)
            if test -d $path/steamapps; and not contains $path/steamapps $libraries
              set --append libraries $path/steamapps
            end
          end
        end

        set --local manifests
        for library in $libraries
          set --append manifests $library/appmanifest_*.acf
        end
        if test (count $manifests) -eq 0
          echo "No installed Steam games found" >&2
          return 1
        end

        set --local game (awk -F'"' '
          FNR == 1 { named = 0 }
          $2 == "appid" { appid = $4 }
          $2 == "name" && !named { print $4 "\t" appid; named = 1 }
        ' $manifests | sort --ignore-case | fzf --delimiter=\t --with-nth=1)

        test -z "$game"; and return 0

        # setsid detaches the game from this shell's process group, so it
        # survives the terminal closing when the picker is a dmenu popup.
        ${pkgs.util-linux}/bin/setsid steam -silent -applaunch (string split --fields 2 \t $game) >/dev/null 2>&1 &
        disown
      '';
    };
  };
  # nixpkgs builds these into share/fish/vendor_*, but home-manager's loader
  # wants the plugin source tree (functions/, completions/, conf.d/).
  plugins =
    map (p: {
      inherit (p) src;
      name = p.pname;
    })
    (with pkgs.fishPlugins; [pure pisces foreign-env]);
}
