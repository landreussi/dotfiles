# sccache and the global cargo config used to be hand-written files in $HOME.
# They live here now so both hosts get the same wiring.
{
  config,
  pkgs,
  ...
}: let
  sccacheConf = "${config.xdg.configHome}/sccache/config";
in {
  home.packages = [pkgs.sccache];

  # The wrapper is an absolute store path, not a bare "sccache": cargo resolves
  # rustc-wrapper through PATH, and a `nix develop` shell replaces PATH with the
  # devshell's own (no ~/.nix-profile/bin), so the bare name breaks every build
  # run inside a project flake that doesn't itself ship sccache.
  #
  # `jobs` caps concurrent rustc processes; peak RAM scales with it, and with
  # 12 cores a big workspace check/clippy runs ~12 multi-GB rustcs at once.
  # Debuginfo is most of rustc codegen and linker memory in `cargo test`, so
  # keep line tables (backtraces still show file:line) and drop it for deps.
  home.file.".cargo/config.toml".text = ''
    [build]
    rustc-wrapper = "${pkgs.sccache}/bin/sccache"
    jobs = 8

    [profile.dev]
    debug = "line-tables-only"

    [profile.dev.package."*"]
    debug = false
  '';

  # sccache reads this from XDG on Linux but from ~/Library/Application Support
  # on darwin, so point SCCACHE_CONF at one path instead of writing two.
  xdg.configFile."sccache/config".text = ''
    [cache.disk]
    dir = "${config.home.homeDirectory}/.cache/sccache"
    size = ${toString (20 * 1024 * 1024 * 1024)}
  '';

  home.sessionVariables = {
    SCCACHE_CONF = sccacheConf;
    # When the client can't reach or spawn its server it fails the whole
    # compile ("sccache: error: Operation not permitted (os error 1)"), which
    # takes down even `cargo clean`. Fall back to calling rustc directly.
    SCCACHE_IGNORE_SERVER_IO_ERROR = "1";
  };
}
