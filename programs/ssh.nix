{ config, pkgs, ... }:

let home = config.users.users.landreussi.home;
in {
  enable = false;
  forwardAgent = true;
  compression = true;
  serverAliveInterval = 30;
  serverAliveCountMax = 5;
  hashKnownHosts = true;
  matchBlocks = {
    identityFile = "${config.users.users.landreussi.home}/.ssh/id_rsa";
    "github.com" = {
      hostname = "github.com";
      user = "git";
      extraOptions = {
        PreferredAuthentications = "publickey";
        AddKeysToAgent = "yes";
      };
    };
  };
}
