{ pkgs, ... }:

{
  programs.xppen = {
    enable = true;
    package = pkgs.xppen_3; # dùng bản 3 theo đúng yêu cầu của bạn
  };
}
