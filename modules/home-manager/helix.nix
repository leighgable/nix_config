{ pkgs, ... }: {
  programs.helix = with pkgs; {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      biome
      clang-tools
      docker-compose-language-service
      dockerfile-language-server-nodejs
      golangci-lint
      golangci-lint-langserver
      gopls
      gotools
      marksman
      nil
      nixpkgs-fmt
      nodePackages.prettier
      nodePackages.typescript-language-server
      pgformatter
      (python3.withPackages (p: (with p; [
        black
        isort
        python-lsp-black
        ruff
      ])))
      rust-analyzer
      taplo
      taplo-lsp
      terraform-ls
      typescript
      vscode-langservers-extracted
      yaml-language-server
    ];

    settings = {
      theme = "gruvbox";  # onedark
      
      editor = {
        color-modes = true;
        cursorline = true;
        bufferline = "multiple";

        soft-wrap.enable = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
          ignore = false;
        };

        indent-guides = {
          character = "┊";
          render = true;
          skip-levels = 1;
        };

        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };

        statusline = {
          left = [ "mode" "file-name" "spinner" "read-only-indicator" "file-modification-indicator" ];
          right = [ "diagnostics" "selections" "register" "file-type" "file-line-ending" "position" ];
          mode.normal = "N";
          mode.insert = "I";
          mode.select = "S";
        };
      };

    };

    languages = {
      language-server.biome = {
        command = "biome";
        args = [ "lsp-proxy" ];
      };

      language-server.gpt = {
        command = "helix-gpt";
        args = [ "--handler" "copilot" ];
      };

      language-server.rust-analyzer.config.check = {
        command = "clippy";
      };

      language-server.yaml-language-server.config.yaml.schemas = {
        kubernetes = "k8s/*.yaml";
      };

      language-server.typescript-language-server.config.tsserver = {
        path = "${pkgs.typescript}/lib/node_modules/typescript/lib/tsserver.js";
      };

      language = [
        {
          name = "css";
          scope = "source.css";
          language-servers = [ "vscode-css-language-server" "gpt" ];
          formatter = {
            command = "prettier";
            args = [ "--stdin-filepath" "file.css" ];
          };
          auto-format = true;
        }
        {
          name = "go";
          scope = "source.go";
          language-servers = [ "gopls" "golangci-lint-lsp" "gpt" ];
          formatter = {
            command = "goimports";
          };
          auto-format = true;
        }
        {
          name = "html";
          scope = "source.html";
          language-servers = [ "vscode-html-language-server" "gpt" ];
          formatter = {
            command = "prettier";
            args = [ "--stdin-filepath" "file.html" ];
          };
          auto-format = true;
        }
        {
          name = "javascript";
          scope = "source.js";
          language-servers = [
            { name = "typescript-language-server"; except-features = [ "format" ]; }
            "biome"
            "gpt"
          ];
          auto-format = true;
        }
        {
          name = "json";
          source = "source.json";
          language-servers = [
            { name = "vscode-json-language-server"; except-features = [ "format" ]; }
            "biome"
          ];
          formatter = {
            command = "biome";
            args = [ "format" "--indent-style" "space" "--stdin-file-path" "file.json" ];
          };
          auto-format = true;
        }
        {
          name = "jsonc";
          source = "source.jsonc";
          language-servers = [
            { name = "vscode-json-language-server"; except-features = [ "format" ]; }
            "biome"
          ];
          formatter = {
            command = "biome";
            args = [ "format" "--indent-style" "space" "--stdin-file-path" "file.jsonc" ];
          };
          file-types = [ "jsonc" "hujson" ];
          auto-format = true;
        }
        {
          name = "jsx";
          source = "source.jsx";
          language-servers = [
            { name = "typescript-language-server"; except-features = [ "format" ]; }
            "biome"
            "gpt"
          ];
          formatter = {
            command = "biome";
            args = [ "format" "--indent-style" "space" "--stdin-file-path" "file.jsx" ];
          };
          auto-format = true;
        }
        {
          name = "markdown";
          source = "source.md";
          language-servers = [ "marksman" "gpt" ];
          formatter = {
            command = "prettier";
            args = [ "--stdin-filepath" "file.md" ];
          };
          auto-format = true;
        }
        {
          name = "nix";
          source = "source.nix";
          formatter = {
            command = "nixpkgs-fmt";
          };
          auto-format = true;
        }
        {
          name = "python";
          source = "source.py";
          language-servers = [ "ruff" ];
          formatter = {
            command = "sh";
            args = [ "-c" "isort --profile black - | black -q -" ];
          };
          auto-format = true;
        }
        {
          name = "rust";
          source = "source.rs";
          language-servers = [ "rust-analyzer" "gpt" ];
          auto-format = true;
        }
        {
          name = "scss";
          source = "source.scss";
          language-servers = [ "vscode-css-language-server" "gpt" ];
          formatter = {
            command = "prettier";
            args = [ "--stdin-filepath" "file.scss" ];
          };
          auto-format = true;
        }
        {
          name = "sql";
          source = "source.sql";
          language-servers = [ "gpt" ];
          formatter = {
            command = "pg_format";
            args = [ "-iu1" "--no-space-function" "-" ];
          };
          auto-format = true;
        }
        {
          name = "toml";
          source = "source.toml";
          language-servers = [ "taplo" ];
          formatter = {
            command = "taplo";
            args = [ "fmt" "-o" "column_width=120" "-" ];
          };
          auto-format = true;
        }
        {
          name = "tsx";
          source = "source.tsx";
          language-servers = [
            { name = "typescript-language-server"; except-features = [ "format" ]; }
            "biome"
            "gpt"
          ];
          formatter = {
            command = "biome";
            args = [ "format" "--indent-style" "space" "--stdin-file-path" "file.tsx" ];
          };
          auto-format = true;
        }
        {
          name = "typescript";
          source = "source.ts";
          language-servers = [
            { name = "typescript-language-server"; except-features = [ "format" ]; }
            "biome"
            "gpt"
          ];
          formatter = {
            command = "biome";
            args = [ "format" "--indent-style" "space" "--stdin-file-path" "file.ts" ];
          };
          auto-format = true;
        }
        {
          name = "yaml";
          source = "source.yml";
          language-servers = [ "yaml-language-server" ];
          formatter = {
            command = "prettier";
            args = [ "--stdin-filepath" "file.yaml" ];
          };
          auto-format = true;
        }
      ];
    };
  };
}
