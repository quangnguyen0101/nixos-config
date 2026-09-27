{ pkgs, inputs, ... }:

let
  # Agents cai tu numtide/llm-agents.nix. Them agent moi vao day de de quan
  # ly, khong tan man trong cac module khac.
  # Luu y: llm-agents bi ghim trong flake.lock, KHONG tu update. Muon ban
  # version moi thi phai tu chay `nix flake update llm-agents`.
  llmAgentPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # Hash node_modules FOD cua llm-agents dang stale (got != specified).
  # Override bang hash thuc te de build duoc.
  opencode-desktop = llmAgentPkgs.opencode-desktop.overrideAttrs (old: {
    node_modules = old.node_modules.overrideAttrs (inner: {
      outputHash = "sha256-qWZuOpolZAr7EZlAgfVx8nw8axoOMauoXwcqiJUGu24=";
    });

    # Desktop build cua llm-agents thieu OPENCODE_VERSION (chi set channel=prod)
    # -> core embedded bake "0.0.0-prod-<builddate>" -> gateway free tier reject
    # ("OpenCode 1.18.0 or newer is required"). Set version de bake dung.
    env = old.env // {
      OPENCODE_VERSION = old.version;
    };
  });

  # Pin codex. Ca llm-agents lan nixpkgs deu build codex tu source
  # (buildRustPackage + librusty_v8): ton V8 download + LLVM toolchain +
  # compile 2 binary Rust => ~30-60 phut moi lan. llm-agents chi expose ban
  # latest (khong co legacyPackages/versioned attrs), nen phai override
  # version + hash de giu nguyen. Hash lay tu hashes.json luc pin.
  # `nix flake update llm-agents` van update agent khac binh thuong.
  codexPinned = llmAgentPkgs.codex.override {
    version = "0.155.1";
    hash = "sha256-iFW66odceRNBsVG5bD9SdcQGxhpm/QIZwYjGCrfMXiI=";
    cargoVendor.cargoHash = "sha256-6IAX/SFSSgSKKFxKsUXoZ9nNQaHJ+EjZ5a4bJwyDdF0=";
    # `librusty_v8` la DERIVATION (fetchurl), nen phai boi mkRustyV8Archive
    # truoc khi truyen vao. Doc hashes.${system} nen chi can x86_64-linux.
    librusty_v8 = llmAgentPkgs.codex.mkRustyV8Archive {
      version = "150.4.0";
      profile = "ptrcomp_sandbox_release";
      baseUrl = "https://github.com/openai/codex/releases/download/rusty-v8-v150.4.0";
      hashes.x86_64-linux = "sha256-o1x10fJuapg4haRbM0kKTr5U8FBQVosyuJz7QhswtYM=";
      srcBindingHashes.x86_64-linux = "sha256-dyeCauR5vbZF6Acjn7EtH44uI956bPFvXuWSaQ0dhQY=";
    };
  };
in

{
  home.packages = [
    opencode-desktop # AI coding agent GUI client
    llmAgentPkgs.freebuff # AI coding agent CLI
    codexPinned # OpenAI Codex CLI (pin 0.155.1, xem comment o tren)
    llmAgentPkgs.chatgpt # ChatGPT desktop app (GUI, unpack .deb chinh thuc; nixpkgs khong co)
  ];

  # OpenCode TUI: dung CLI tu llm-agents.nix (config thuoc ve opencode.nix)
  programs.opencode.package = llmAgentPkgs.opencode;
}
