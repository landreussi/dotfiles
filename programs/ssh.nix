{ config, ... }:

let home = config.users.users.landreussi.home;
in {
  enable = true;
  forwardAgent = true;
  addKeysToAgent = "yes";
  compression = true;
  serverAliveInterval = 30;
  serverAliveCountMax = 5;
  hashKnownHosts = true;
  matchBlocks = {
    "github.com" = {
      identityFile = "${home}/.ssh/id_rsa";
      hostname = "github.com";
      user = "git";
      extraOptions = {
        PreferredAuthentications = "publickey";
        AddKeysToAgent = "yes";
      };
    };
  };
}
