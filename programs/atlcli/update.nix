{
  writeShellApplication,
  cacert,
  coreutils,
  curl,
  gawk,
  jq,
}:
writeShellApplication {
  name = "atlcli-update-pins";
  runtimeInputs = [cacert coreutils curl gawk jq];
  text = builtins.readFile ./update.sh;
}
