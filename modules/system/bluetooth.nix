{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    #powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Force the Bluetooth service to shut down after 10 seconds if it hangs.
  # systemd.services.bluetooth.serviceConfig.TimeoutSec = "10";
  systemd.services.bluetooth.serviceConfig.TimeoutStopSec = "10";
}
