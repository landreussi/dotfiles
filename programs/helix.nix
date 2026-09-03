{
  pkgs,
  lib,
  ...
}: {
  enable = true;
  settings = {
    theme = "varua";
    editor = {
      auto-save = true;
      cursorline = true;
      lsp = {
        display-messages = true;
        display-progress-messages = true;
        display-inlay-hints = true;
      };
      cursor-shape.insert = "bar";
      line-number = "relative";
      completion-timeout = 5;
      completion-replace = false;
      color-modes = true;
      popup-border = "popup";
      default-yank-register = "+";
      statusline = {
        left = [
          "mode"
          "file-name"
          "read-only-indicator"
          "file-modification-indicator"
        ];
        right = ["diagnostics" "position" "file-encoding"];
      };
      end-of-line-diagnostics = "hint";
      inline-diagnostics = {
        cursor-line = "warning";
        other-lines = "warning";
      };
    };
    keys.normal = {
      Z = {Z = ":bc";};
      tab = "rotate_view";
      ";" = {
        f = "file_picker";
        b = "buffer_picker";
        s = "symbol_picker";
        a = "code_action";
        r = "rename_symbol";
        k = "hover";
        "/" = "global_search";
      };
    };
  };
  languages.language-server.rust-analyzer.config = {
    assist.emitMustUse = true;
    cargo.features = "all";
    check.command = "clippy";
    checkOnSave = true;
    completion = {
      limit = 20;
      termSearch.enable = true;
    };
    imports.prefix = "crate";
    inlayHints = {
      expressionAdjustmentHints = {
        enable = "always";
        hideOutsideUnsafe = true;
      };
      lifetimeElisionHints.useParameterNames = true;
      typeHints.hideNamedConstructor = true;
    };
    lens = {
      references = {
        adt.enable = true;
        method.enable = true;
        trait.enable = true;
      };
      run.enable = false;
    };
    references.excludeImports = true;
  };
  languages.language-server.yaml-language-server.config = {
    yaml.keyOrdering = false;
  };
  languages.language-server.fs_watcher_lsp = {
    command = lib.getExe pkgs.fs-watcher-lsp;
    args = [];
  };
  languages.language-server.vscode-eslint-ls = {
    command = "${pkgs.vscode-langservers-extracted}/lib/eslint-language-server";
    args = [];
  };
  languages.language-server.typescript-language-server.config.plugins = [
    {
      name = "@vue/typescript-plugin";
      location = "${pkgs.vue-language-server}/lib/language-tools/packages/typescript-plugin";
      languages = ["vue"];
    }
  ];
  languages.language-server.nil.command = lib.getExe pkgs.nil;
  languages.language-server.taplo.command = lib.getExe pkgs.taplo;
  languages.language-server.jdtls.command = lib.getExe pkgs.jdt-language-server;
  languages.language-server.clangd.command = "${pkgs.clang-tools}/bin/clangd";
  languages.language-server.docker-langserver = {
    command = "${pkgs.dockerfile-language-server}/bin/docker-langserver";
    args = ["--stdio"];
  };
  languages.language-server.gopls.command = lib.getExe pkgs.gopls;
  languages.language-server.zls.command = lib.getExe pkgs.zls;
  languages.language-server.clojure-lsp.command = lib.getExe pkgs.clojure-lsp;
  languages.language-server.terraform-ls = {
    command = lib.getExe pkgs.terraform-ls;
    args = ["serve"];
  };
  languages.language-server.sqls.command = lib.getExe pkgs.sqls;
  languages.language = [
    {
      name = "python";
      language-servers = ["pylyzer" "fs_watcher_lsp"];
    }
    {
      name = "rust";
      language-servers = ["rust-analyzer" "fs_watcher_lsp"];
    }
    {
      name = "nix";
      auto-format = true;
      formatter.command = lib.getExe pkgs.alejandra;
      language-servers = ["nil" "fs_watcher_lsp"];
    }
    {
      name = "javascript";
      language-servers = ["typescript-language-server" "vscode-eslint-ls" "fs_watcher_lsp"];
    }
    {
      name = "jsx";
      language-servers = ["typescript-language-server" "vscode-eslint-ls" "fs_watcher_lsp"];
    }
    {
      name = "typescript";
      language-servers = ["typescript-language-server" "vscode-eslint-ls" "fs_watcher_lsp"];
    }
    {
      name = "tsx";
      language-servers = ["typescript-language-server" "vscode-eslint-ls" "fs_watcher_lsp"];
    }
    {
      name = "vue";
      auto-format = true;
      formatter = {
        command = lib.getExe pkgs.prettier;
        args = ["--parser" "vue"];
      };
      language-servers = ["typescript-language-server" "fs_watcher_lsp"];
    }
    {
      name = "toml";
      language-servers = ["taplo" "fs_watcher_lsp"];
    }
    {
      name = "java";
      language-servers = ["jdtls" "fs_watcher_lsp"];
    }
    {
      name = "c";
      language-servers = ["clangd" "fs_watcher_lsp"];
    }
    {
      name = "cpp";
      language-servers = ["clangd" "fs_watcher_lsp"];
    }
    {
      name = "dockerfile";
      language-servers = ["docker-langserver" "fs_watcher_lsp"];
    }
    {
      name = "go";
      language-servers = ["gopls" "fs_watcher_lsp"];
    }
    {
      name = "zig";
      language-servers = ["zls" "fs_watcher_lsp"];
    }
    {
      name = "hcl";
      language-id = "terraform";
      language-servers = ["terraform-ls" "fs_watcher_lsp"];
    }
    {
      name = "tfvars";
      language-id = "terraform-vars";
      language-servers = ["terraform-ls" "fs_watcher_lsp"];
    }
    {
      name = "sql";
      language-servers = ["sqls" "fs_watcher_lsp"];
    }
    {
      name = "clojure";
      language-servers = ["clojure-lsp" "fs_watcher_lsp"];
    }
  ];
}
