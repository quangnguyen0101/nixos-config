{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.python314.withPackages (
      ps: with ps; [
        pip
        numpy
        requests
        pandas
        mutagen
      ]
    ))
  ];
}
