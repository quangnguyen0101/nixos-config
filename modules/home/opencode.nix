{ pkgs, config, ... }:

{
  # Agents tu llm-agents.nix (opencode-desktop, freebuff, opencode CLI...)
  # duoc cai trong modules/home/llm-agents.nix

  # Shell strategy instructions + global skills: vender trong repo, home-manager
  # copy ra ~/.config/opencode/ de opencode doc duoc.
  home.file = {
    ".config/opencode/shell_strategy.md".source = ./../../pkgs/opencode/shell_strategy.md;
    ".config/opencode/skills/data-science/SKILL.md".source =
      ./../../pkgs/opencode/skills/data-science/SKILL.md;
    # Archify (vendored tt-a1i/archify, MIT): renderer JSON-IR -> HTML/SVG diagrams.
    # Can node >=18 (da co tren he thong). Rut gon: bo test/ va examples/*.html (proof artifacts).
    ".config/opencode/skills/archify".source = ./../../pkgs/opencode/skills/archify;
    # LaTeX documents (vendored ndpvt-web/latex-document-skill, MIT): compile any
    # LaTeX to PDF + PNG previews, 28 templates + ATS resumes, charts/mermaid/
    # graphviz, mail merge, pdf fill/extract. Rut gon: bo examples (giu 3 ieee
    # refs), mascot png, tests/, stats/. Pi deps: matplotlib numpy pandas jinja2.
    ".config/opencode/skills/latex-document-skill".source =
      ./../../pkgs/opencode/skills/latex-document-skill;
    # Defuddle (vendored kepano/obsidian-skills, MIT): HTML -> Markdown, dung CLI defuddle.
    ".config/opencode/skills/defuddle".source = ./../../pkgs/opencode/skills/defuddle;
    # Manim skills (vendored): adithya-s-k/manim_skill (MIT) — manim-composer (lap
    # ke hoach video) + manimce-best-practices (24 rule + example + template, thuan
    # markdown, khong dep). Yusuke710/manim-skill (MIT) — workflow render + TTS
    # voiceover; tools/ goi `python` can kokoro+soundfile (co trong jupyterEnv).
    ".config/opencode/skills/manim-composer".source = ./../../pkgs/opencode/skills/manim-composer;
    ".config/opencode/skills/manimce-best-practices".source =
      ./../../pkgs/opencode/skills/manimce-best-practices;
    ".config/opencode/skills/manim-skill".source = ./../../pkgs/opencode/skills/manim-skill;
  };

  programs.opencode = {
    enable = true;

    extraPackages = [ pkgs.nixd ]; # LSP server cho .nix (còn lại opencode tự cài)

    settings = {
      # Default model cho ca TUI lan headless `opencode run`. Format provider/model.
      model = "ollama/gpt-oss:120b-cloud";

      lsp = true;

      # Shell non-interactive strategy (vendored tu JRedeker/opencode-shell-strategy).
      # Tai ke khi mở session -> chấm dứt shell command hang vi cho TTY.
      instructions = [ "${config.home.homeDirectory}/.config/opencode/shell_strategy.md" ];

      mcp = {
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
        docker = {
          type = "local";
          enabled = true;
          command = [
            "npx"
            "-y"
            "@hypnosis/docker-mcp-server@2.0.1"
          ];
          environment.DOCKER_HOST = "unix:///var/run/docker.sock";
        };
        postgres = {
          type = "local";
          enabled = true;
          command = [
            "uvx"
            "--overrides"
            # postgres-mcp ghim pglast==7.2.0 (không tồn tại trên PyPI) →
            # override sang 7.21. Xem file để biết chi tiết.
            ./../../pkgs/opencode/postgres-mcp-overrides.txt
            "--from"
            "postgres-mcp==0.3.0"
            "--with"
            "mcp<2"
            "postgres-mcp"
            "postgresql://dsuser:dssecret@127.0.0.1:5432/datascience"
          ];
          environment.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        };
        jupyter = {
          type = "local";
          enabled = true;
          command = [
            "uvx"
            "--from"
            "jupyter-mcp-server==2.1.15" # pin version (npm cung ten, dung uvx)
            "jupyter-mcp-server"
          ];
          environment = {
            JUPYTER_URL = "http://127.0.0.1:8888";
            JUPYTER_TOKEN = "jupylocal-ds";
            ALLOW_IMG_OUTPUT = "true";
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
            "gemma4:cloud" = {
              name = "Gemma 4";
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
            };
            "nomic-embed-text:latest" = {
              name = "Nomic Embed Text";
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
          };
        };
      };
    };

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
