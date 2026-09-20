{ pkgs, inputs, ... }:

let
  # Agents cai tu numtide/llm-agents.nix (auto update daily). Them agent moi
  # vao day de de quan ly, khong tan man trong cac module khac.
  llmAgentPkgs = inputs.llm-agents.packages.${pkgs.system};

  # Hash node_modules FOD cua llm-agents dang stale (got != specified).
  # Override bang hash thuc te de build duoc.
  opencode-desktop = llmAgentPkgs.opencode-desktop.overrideAttrs (old: {
    node_modules = old.node_modules.overrideAttrs (inner: {
      outputHash = "sha256-qWZuOpolZAr7EZlAgfVx8nw8axoOMauoXwcqiJUGu24=";
    });
  });
in

{
  home.packages = [
    opencode-desktop # AI coding agent GUI client
    llmAgentPkgs.freebuff # AI coding agent CLI
  ];

  # OpenCode TUI: dung CLI tu llm-agents.nix (config thuoc ve opencode.nix)
  programs.opencode.package = llmAgentPkgs.opencode;
}