{ config, pkgs, ... }:

{
	programs.regreet = {
		enable = true;
		#theme.name = "Adwaita";
		#font = {
		#	name = "Cantarell";
		#	size = 16;
		#};
		#cursorTheme.name = "Adwaita";

		cageArgs = [
			"-s"
			"-d"
			"-m"
			"last"
		];

		theme.package = pkgs.gnome-themes-extra;
  		theme.name = "Adwaita-dark";

		font.package = pkgs.jetbrains-mono;
		font.name = "JetBrainsMono Nerd Font";
		font.size = 14;

		cursorTheme.package = pkgs.adwaita-icon-theme;
		cursorTheme.name = "Adwaita";
				
		iconTheme.package = pkgs.adwaita-icon-theme;
		iconTheme.name = "Adwaita";

		extraCss = ''
  /* ===== Rosé Pine Palette ===== */
  @define-color base #191724;
  @define-color surface #1f1d2e;
  @define-color overlay #26233a;
  @define-color muted #6e6a86;
  @define-color subtle #908caa;
  @define-color text #e0def4;
  @define-color love #eb6f92;
  @define-color gold #f6c177;
  @define-color rose #ebbcba;
  @define-color pine #31748f;
  @define-color foam #9ccfd8;
  @define-color iris #c4a7e7;

  window {
    background: linear-gradient(135deg, @base 0%, @surface 100%);
    color: @text;
    font-family: "JetBrainsMono Nerd Font";
  }

  /* Khung chứa form login */
  box.background {
    background-color: alpha(@surface, 0.75);
    border-radius: 20px;
    border: 1px solid alpha(@iris, 0.25);
    padding: 32px;
  }

  /* Label chữ (username, session...) */
  label {
    color: @subtle;
    font-weight: 500;
  }

  /* Ô nhập username/password */
  entry {
    background-color: @overlay;
    color: @text;
    border: 2px solid alpha(@muted, 0.3);
    border-radius: 14px;
    padding: 10px 16px;
    caret-color: @foam;
    transition: border-color 200ms ease, box-shadow 200ms ease;
  }

  entry:focus {
    border-color: @iris;
    box-shadow: 0 0 0 3px alpha(@iris, 0.2);
  }

  /* Nút Login/Reboot/Shutdown */
  button {
    background-color: @overlay;
    color: @text;
    border-radius: 12px;
    border: 1px solid alpha(@muted, 0.25);
    padding: 8px 20px;
    transition: all 150ms ease;
  }

  button:hover {
    background-color: @pine;
    color: @base;
  }

  button:active {
    background-color: @foam;
  }

  /* Nút Login chính, nổi bật hơn nút phụ */
  button.suggested-action {
    background-color: @iris;
    color: @base;
    font-weight: 700;
  }

  button.suggested-action:hover {
    background-color: @rose;
  }

  /* Dropdown chọn session/user */
  dropdown, combobox {
    background-color: @overlay;
    color: @text;
    border-radius: 12px;
    border: 1px solid alpha(@muted, 0.3);
  }

  /* Thông báo lỗi (sai password...) */
  .error {
    color: @love;
    font-weight: 600;
  }

  /* Đồng hồ/ngày giờ nếu có */
  .clock {
    color: @gold;
    font-size: 32px;
    font-weight: 300;
  }
'';
	};

	services.greetd = {
		enable = true;
	};
}
