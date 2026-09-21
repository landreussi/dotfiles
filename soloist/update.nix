{
  writeShellApplication,
  cacert,
  coreutils,
  curl,
  gnutar,
  gzip,
  jq,
}:
writeShellApplication {
  name = "soloist-update-pins";
  runtimeInputs = [cacert coreutils curl gnutar gzip jq];
  text = builtins.readFile ./update.sh;
}
