{
  enable = true;
  enableDefaultConfig = false;
  matchBlocks = {
    "github.com" = {
      identitiesOnly = true;
      hostname = "github.com";
      hashKnownHosts = true;
      serverAliveInterval = 30;
      serverAliveCountMax = 5;
      forwardAgent = true;
      compression = true;
      addKeysToAgent = "yes";
    };
    "gitlab.com" = {
      identitiesOnly = true;
      hostname = "gitlab.com";
      hashKnownHosts = true;
      serverAliveInterval = 30;
      serverAliveCountMax = 5;
      forwardAgent = true;
      compression = true;
      addKeysToAgent = "yes";
    };
  };
}
