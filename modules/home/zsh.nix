{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      tr = "tree";
      clr = "clear";
      shut = "shutdown -h now";
      op = "opencode";
      nx = "cd ~/nixos-config";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw";
    };

    oh-my-zsh = {
      enable = true;
      # Prompt do oh-my-posh lo; theme rỗng = OMZ không load theme nào
      # (oh-my-zsh.sh chỉ source theme khi ZSH_THEME khác rỗng).
      theme = "";
      plugins = [
        "git"
        "sudo"
        "docker"
        "history-substring-search"
      ];
    };

    # Thêm Zsh function và script khởi động vào đây
    initContent = ''
      # Graphical session display env (Hyprland): phục hồi khi pane tmux cũ thiếu.
      # Chỉ áp khi đang có X-wayland socket, không phải SSH.
      if [ -z "$SSH_CONNECTION" ]; then
        if [ -e /tmp/.X11-unix/X0 ] && [ -z "$DISPLAY" ]; then
          export DISPLAY=":0"
        fi
        if [ -n "$XDG_RUNTIME_DIR" ] && [ -e "$XDG_RUNTIME_DIR/wayland-1" ] && [ -z "$WAYLAND_DISPLAY" ]; then
          export WAYLAND_DISPLAY="wayland-1"
        fi
      fi

      # Tự động chạy TMUX
      if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
        exec tmux new-session -A -s main
      fi

      # Zsh Function để update rmpc nhanh
      ru() {
        rmpc update
        echo "🎵 Kho nhạc đã được cập nhật thành công!"
        sleep 3
        rmpc
      }

      # Quét virus: tự cập nhật DB trước, rồi quét. DB path đọc từ
      # /etc/clamav/freshclam.conf nên không cần -d.
      # Tên khác binary (cs vs clamscan) nên không đệ quy, khỏi cần `command`.
      # freshclam lỗi (mất mạng) vẫn quét bằng DB cũ, và exit code là
      # của clamscan: 0 sạch, 1 có virus, 2 lỗi.
      cs() {
        freshclam
        clamscan "$@"
      }
    '';
  };

  # Prompt kiểu atomic (oh-my-posh), đổi màu sang Catppuccin Frappe cho khớp
  # Ghostty. Chỉ báo keep-awake ⚡ nằm trong theme (segment command), không
  # dùng RPROMPT nữa để khỏi đè right-block của oh-my-posh.
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./oh-my-posh/frappe.omp.json;
  };
}
