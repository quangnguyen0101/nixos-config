{ pkgs, config, ... }:

{
  home.packages = [
    pkgs.opencode-desktop # AI coding agent GUI client
  ];

  # Shell strategy instructions + global skills: vender trong repo, home-manager
  # copy ra ~/.config/opencode/ de opencode doc duoc.
  home.file = {
    ".config/opencode/shell_strategy.md".source = ./../../pkgs/opencode/shell_strategy.md;
    ".config/opencode/skills/data-science/SKILL.md".source = ./../../pkgs/opencode/skills/data-science/SKILL.md;
    # Archify (vendored tt-a1i/archify, MIT): renderer JSON-IR -> HTML/SVG diagrams.
    # Can node >=18 (da co tren he thong). Rut gon: bo test/ va examples/*.html (proof artifacts).
    ".config/opencode/skills/archify".source = ./../../pkgs/opencode/skills/archify;
  };

  programs.opencode = {
    enable = true;

    extraPackages = [ pkgs.nixd ]; # LSP server cho .nix (còn lại opencode tự cài)

    settings = {
      lsp = true;

      # Shell non-interactive strategy (vendored tu JRedeker/opencode-shell-strategy).
      # Tai ke khi mở session -> chấm dứt shell command hang vi cho TTY.
      instructions = [ "${config.home.homeDirectory}/.config/opencode/shell_strategy.md" ];

      # Ouroboros bridge plugin: chặn _subagent envelope từ MCP ouroboros, dispatch
      # ra Task panes của opencode. File tĩnh từ wheel ouroboros-ai 0.54.4
      # (version-agnostic, chi doc cap version MCP args). sync khi nang version.
      plugin = [ "${./../../pkgs/ouroboros/ouroboros-bridge.ts}" ];

      mcp = {
        openviking = {
          type = "remote";
          url = "http://127.0.0.1:1933/mcp";
        };
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
        github = {
          type = "remote";
          url = "https://api.githubcopilot.com/mcp/";
          oauth = false; # GitHub khong ho tro DCR -> dung PAT trong header
          headers.Authorization = "Bearer {file:~/.config/opencode/github.token}";
        };
        ouroboros = {
          type = "local";
          enabled = true;
          command = [
            "uvx" "--from" "ouroboros-ai[mcp]==0.54.4" # pin version MCP server
            "ouroboros" "mcp" "serve" "--runtime" "opencode"
          ];
          environment.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        };
        docker = {
          type = "local";
          enabled = true;
          command = [
            "npx" "-y" "@hypnosis/docker-mcp-server@2.0.1"
          ];
          environment.DOCKER_HOST = "unix:///var/run/docker.sock";
        };
        postgres = {
          type = "local";
          enabled = true;
          command = [
            "uvx" "--from" "postgres-mcp==0.3.0" "--with" "mcp<2"
            "postgres-mcp" "postgresql://dsuser:dssecret@127.0.0.1:5432/datascience"
          ];
          environment.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        };
        arxiv = {
          type = "local";
          enabled = true;
          timeout = 120000; # arXiv rate-limit (429): retry budget 62s > default 30s
          command = [
            "uvx" "--from" "arxiv-mcp-server[pdf]==0.7.2" # pin version, [pdf] de dang roi PDF fallback
            "arxiv-mcp-server"
          ];
          environment.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        };
        jupyter = {
          type = "local";
          enabled = true;
          command = [
            "uvx" "--from" "jupyter-mcp-server==2.1.15" # pin version (npm cung ten, dung uvx)
            "jupyter-mcp-server"
          ];
          environment = {
            JUPYTER_URL = "http://127.0.0.1:8888";
            JUPYTER_TOKEN = "jupylocal-ds";
            ALLOW_IMG_OUTPUT = "true";
            LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
          };
        };
        vision = {
          type = "local";
          enabled = true;
          timeout = 120000; # cold download paddleocr (paddle extra) ~2min
          command = [
            "uvx" "--from" "opencode-vision[paddle]==2.1.0" # PaddleOCR local + Gemini free fallback
            "python3" "${./../../pkgs/opencode/vision-mcp-wrapper.py}" # patch: newline framing + protocolVersion
          ];
          environment = {
            # Gemini API key: file ngoai repo (600), khong commit len public github
            GOOGLE_API_KEY = "{file:~/.config/opencode/gemini.key}";
            LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
          };
        };
      };

      attachment = {
        image = {
          auto_resize = true;
          max_width = 1024;
          max_height = 1024;
          max_base64_bytes = 2097152;
        };
      };

      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options.baseURL = "http://localhost:11434/v1";
          models = {
            "nemotron-3-super:cloud" = {
              name = "Nemotron 3 Super";
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
            };
            "gpt-oss:120b-cloud" = {
              name = "GPT-OSS 120B";
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
            };
            "gemma4:31b-cloud" = {
              name = "Gemma 4 31B";
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
            };
          };
        };
      };
    };

    tui.display_thinking = true;
  };

  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama LLM server (user session, uses ~/.ollama auth)";
      StartLimitIntervalSec = 60;
      StartLimitBurst = 5;
    };

    Service = {
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Environment = "HOME=%h";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
