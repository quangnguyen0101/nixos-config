{ pkgs, ... }:

{
	fonts.packages = with pkgs; [
    		nerd-fonts.jetbrains-mono   # font có icon, cần cho bar/terminal hiện đại
    		nerd-fonts.fira-code
		nerd-fonts.hack
		nerd-fonts._0xproto
		noto-fonts                 # font cơ bản, hiển thị đa ngôn ngữ
		noto-fonts-cjk-sans        # tiếng Trung/Nhật/Hàn nếu cần
		noto-fonts-color-emoji          # emoji 🎉
	];

  	fonts.fontconfig.enable = true;
}
