{ config, pkgs, lib, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    # Global NVIDIA offload cho MỌI game (không cần nvidia-offload %command%
    # từng game) — env kế thừa qua toàn bộ process Steam spawn.
    package = pkgs.steam.override {
      extraEnv = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA Optimus (Intel UHD 630 + GeForce MX150) — PRIME offload:
  # desktop render bằng Intel, game dùng NVIDIA qua `nvidia-offload %command%`.
  hardware.nvidia = {
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
