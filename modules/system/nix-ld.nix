# nix-ld: cho phép binary/wheel nhị phân dựng ngoài nix (pip wheels qua uv,
# uvx tool như ouroboros, v.v.) tìm được loader và thư viện hệ thống.
# libstdc++ cần cho các C-extension wheel (greenlet, pydantic-core, ...).
{
  lib,
  pkgs,
  ...
}:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
    ];
  };
}
