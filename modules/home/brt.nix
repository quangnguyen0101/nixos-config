{ pkgs, ... }:

let
  brt = pkgs.writeShellScriptBin "brt" (builtins.readFile ./brt-config/brt);
in
{
  home.packages = [ brt ];
}
