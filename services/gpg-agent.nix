{pkgs, ...}: {
  enable = true;
  enableSshSupport = true;
  enableFishIntegration = true;
  enableExtraSocket = true;
  grabKeyboardAndMouse = false;
  pinentry = {package = pkgs.pinentry-curses;};
}
