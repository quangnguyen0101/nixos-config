{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      # ─── FONT ────────────────────────────────────────
      font-family = "0xProto Nerd Font";
      font-family-bold = "0xProto Nerd Font";
      font-family-italic = "0xProto Nerd Font";
      font-size = 14;
      font-thicken = true;
      font-synthetic-style = "bold-italic";
      font-feature = "-calt";
      adjust-cell-height = 3;
      adjust-cursor-thickness = 2;

      # ─── THEME & MÀU SẮC ─────────────────────────────
      theme = "light:Catppuccin Latte,dark:Catppuccin Frappe";
      alpha-blending = "linear-corrected";

      # ─── CURSOR ──────────────────────────────────────
      cursor-style = "bar";
      cursor-style-blink = true;
      cursor-color = "cell-foreground";
      cursor-text = "cell-background";

      # ─── CỬA SỔ ───────────────────────────────────────
      window-padding-x = 12;
      window-padding-y = 8;
      window-padding-balance = true;
      window-save-state = "always";
      window-decoration = "auto";
      background-opacity = 0.95;
      background-blur-radius = 20;
      working-directory = "home";
      window-inherit-working-directory = true;
      quit-after-last-window-closed = true;

      # ─── SHELL ────────────────────────────────────────
      shell-integration = "detect";
      shell-integration-features = "sudo,title,no-cursor";

      # ─── MISC ─────────────────────────────────────────
      mouse-hide-while-typing = true;
      mouse-scroll-multiplier = 3;
      scrollback-limit = 10000;
      clipboard-read = "allow";
      clipboard-write = "allow";
      "copy-on-select" = false;

      # ─── KEYBINDS: FONT SIZE ──────────────────────────
      keybind = [
        "ctrl+equal=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+0=reset_font_size"
        "ctrl+shift+comma=reload_config"
      ];
    };
  };
}
