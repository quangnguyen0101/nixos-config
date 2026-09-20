{ pkgs, inputs, ... }:

let
  # Agents cai tu numtide/llm-agents.nix (auto update daily). Them agent moi
  # vao day de de quan ly, khong tan man trong cac module khac.
  llmAgentPkgs = inputs.llm-agents.packages.${pkgs.system};
in

{
  home.packages = [
    llmAgentPkgs.opencode-desktop # AI coding agent GUI client
    llmAgentPkgs.freebuff # AI coding agent CLI
  ];

  # OpenCode TUI: dung CLI tu llm-agents.nix (config thuoc ve opencode.nix)
  programs.opencode.package = llmAgentPkgs.opencode;
}