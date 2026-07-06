{ config, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Bonus: tự tối ưu hóa store, giảm dung lượng trùng lặp
  nix.optimise.automatic = true;
}
