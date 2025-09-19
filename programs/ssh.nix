{
  enable = true;
  forwardAgent = true;
  addKeysToAgent = "yes";
  compression = true;
  serverAliveInterval = 30;
  serverAliveCountMax = 5;
  hashKnownHosts = true;
  matchBlocks = {
    "github.com" = {
      identitiesOnly = true;
      hostname = "github.com";
    };
    "gitlab.com" = {
      identitiesOnly = true;
      hostname = "gitlab.com";
    };
  };
}
