# Spotify only ships prebuilt Linux binaries for Soloist; there is no source
# release and no nixpkgs package, so this unpacks the official archive and
# patches it for the Nix store.
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libpulseaudio,
  pipewire,
  pins ? lib.importJSON ./pins.json,
  # Both backends are optional at runtime: soloist dlopens whichever one it
  # finds. pipewire drags in a ~600 MiB closure, so a PulseAudio-only host is
  # better off building without it.
  withPipeWire ? true,
  withPulseAudio ? true,
}: let
  # Upstream names its archives after its own arch labels, not Nix's.
  archives = {
    x86_64-linux = "x86_64";
    aarch64-linux = "arm64";
    armv7l-linux = "arm32";
    armv6l-linux = "arm32";
  };
  arch =
    archives.${stdenv.hostPlatform.system}
    or (throw "soloist: Spotify publishes no build for ${stdenv.hostPlatform.system}");
  pin = pins.archives.${arch};
in
  stdenv.mkDerivation {
    pname = "soloist";
    # The download URL carries no version, so the build stamp is what actually
    # distinguishes one archive from the next.
    version = "${pins.release}-${pin.build}";

    src = fetchurl {inherit (pin) url sha256;};

    # Flat archive: soloist, CHANGELOG.md, THIRD_PARTY_LICENSES.txt, no
    # top-level directory.
    sourceRoot = ".";

    nativeBuildInputs = [autoPatchelfHook];

    # libatomic.so.1 and libgcc_s.so.1 come from the gcc runtime.
    buildInputs = [stdenv.cc.cc.lib];

    # Both audio backends are dlopen'd, so they never appear in DT_NEEDED and
    # autoPatchelf cannot discover them. runtimeDependencies appends them to
    # the RPATH anyway.
    runtimeDependencies =
      lib.optional withPulseAudio libpulseaudio
      ++ lib.optional withPipeWire pipewire;

    installPhase = ''
      runHook preInstall
      install -Dm755 soloist $out/bin/soloist
      install -Dm644 CHANGELOG.md -t $out/share/doc/soloist
      install -Dm644 THIRD_PARTY_LICENSES.txt -t $out/share/doc/soloist
      runHook postInstall
    '';

    # Builds refuse to run 90 days after they were made, exiting with code 10.
    passthru = {
      inherit pins;
      inherit (pin) build expires;
    };

    meta = {
      description = "Headless Spotify Connect player with a CLI and WebSocket API";
      homepage = "https://developer.spotify.com/documentation/soloist";
      # Prebuilt and explicitly not redistributable: every consumer fetches
      # from Spotify's CDN itself.
      license = lib.licenses.unfree;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = lib.attrNames archives;
      mainProgram = "soloist";
    };
  }
