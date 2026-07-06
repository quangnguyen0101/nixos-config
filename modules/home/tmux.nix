{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh"; # mở pane mới cũng dùng zsh, đồng bộ với shell chính
    terminal = "screen-256color";
    historyLimit = 10000;
    mouse = true; # bật chuột (chọn pane, resize, scroll) — rất nên có
    baseIndex = 1; # window/pane đánh số từ 1 thay vì 0, dễ bấm phím
    escapeTime = 0; # giảm delay khi nhấn ESC (quan trọng nếu dùng vim/neovim trong tmux)

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = ''
          				set -g @rose_pine_variant 'main'
          				set -g @rose_pine_host 'on'
          				set -g @rose_pine_date_time '%H:%M'
          				set -g @rose_pine_directory 'on'
          				set -g @rose_pine_bar_bg_disable 'off'
          				'';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          				set -g @resurrect-strategy-vim 'session'
          				set -g @resurrect-strategy-nvim 'session'
          				set -g @resurrect-capture-pane-contents 'on'
          				'';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          				set -g @continuum-restore 'on'
          				set -g @continuum-save-interval '10'
          				'';
      }
    ];
    extraConfig = ''
      	      		# Đổi prefix từ Ctrl+B sang Ctrl+A (dễ bấm hơn, ít xung đột với terminal khác)
      	      		unbind C-b
      	      		set -g prefix C-a
      	      		bind C-a send-prefix

      	      		# Chia pane bằng | và - thay vì % và " (dễ nhớ hơn)
      	      		bind | split-window -h
      	      		bind - split-window -v

      	      		# Di chuyển giữa pane bằng Vim-style (h j k l)
      	      		bind h select-pane -L
      	      		bind j select-pane -D
      	      		bind k select-pane -U
      	      		bind l select-pane -R

      	      		# Reload config nhanh bằng prefix + r
      	      		bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      		'';
  };
}
