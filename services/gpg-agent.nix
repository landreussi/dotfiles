{ pkgs, ... }:

{
  enable = true;
  enableSshSupport = true;
  enableFishIntegration = true;
  pinentry = { package = pkgs.pinentry-curses; };
}
