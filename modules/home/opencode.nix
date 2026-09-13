{ pkgs, ... }:

{
  home.packages = [
    pkgs.opencode-desktop # AI coding agent GUI client
  ];

  programs.opencode = {
    enable = true;

    extraPackages = [ pkgs.nixd ]; # LSP server cho .nix (còn lại opencode tự cài)

    settings = {
      lsp = true;

      # Ouroboros bridge plugin: chặn _subagent envelope từ MCP ouroboros, dispatch
      # ra Task panes của opencode. File tĩnh từ wheel ouroboros-ai 0.54.4
      # (version-agnostic, chi doc cap version MCP args). sync khi nang version.
      plugin = [ "${./../../pkgs/ouroboros/ouroboros-bridge.ts}" ];

      mcp = {
        openviking = {
          type = "remote";
          url = "http://127.0.0.1:1933/mcp";
        };
        github = {
          type = "remote";
          url = "https://api.githubcopilot.com/mcp/";
          oauth = false; # GitHub khong ho tro DCR -> dung PAT trong header
          headers.Authorization = "Bearer {file:~/.config/opencode/github.token}";
        };
        ouroboros = {
          type = "local";
          command = "uvx";
          args = [
            "--from" "ouroboros-ai[mcp]==0.54.4" # pin version MCP server
            "ouroboros" "mcp" "serve" "--runtime" "opencode"
          ];
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
