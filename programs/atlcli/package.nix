# atlcli is TypeScript compiled into a single executable with `bun build
# --compile`, plus a small Rust NFS helper. Upstream publishes both prebuilt for
# every platform it supports, which beats reproducing its bun + cargo build in
# Nix, so this unpacks the release archive and patches it for the store.
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
}: let
  pins = lib.importJSON ./pins.json;

  # Upstream names its archives after its own platform labels, not Nix's.
  archives = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };
  platform =
    archives.${stdenv.hostPlatform.system}
    or (throw "atlcli: upstream publishes no build for ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "atlcli";
    inherit (pins) version;

    src = fetchurl {
      url = "https://github.com/BjoernSchotte/atlcli/releases/download/v${pins.version}/atlcli-${platform}.tar.gz";
      sha256 = pins.sha256.${platform};
    };

    # Flat archive: atlcli, atlcli-confluence-nfs and the helper's notices, no
    # top-level directory.
    sourceRoot = ".";

    nativeBuildInputs = [makeWrapper] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

    # libgcc_s.so.1 for the Rust NFS helper; everything else is plain glibc.
    buildInputs = lib.optional stdenv.hostPlatform.isLinux stdenv.cc.cc.lib;

    # The bundled JS and assets live inside the executable (an ELF section on
    # Linux, a Mach-O segment on macOS). Leave the binaries byte-for-byte alone
    # beyond the interpreter/RPATH, which also keeps the macOS signature valid.
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      # `wiki mount` looks for the NFS helper next to the running executable,
      # never on PATH, so the two have to share a directory.
      install -Dm755 atlcli atlcli-confluence-nfs -t $out/bin
      install -Dm644 LICENSE-nfsserve THIRD-PARTY-nfs.html -t $out/share/doc/atlcli

      # The store is read-only, so `atlcli update` cannot replace itself and the
      # daily "Update available" nag only points at something that fails. New
      # versions come in through pins.json instead.
      wrapProgram $out/bin/atlcli --set-default ATLCLI_DISABLE_UPDATE_CHECK 1

      runHook postInstall
    '';

    meta = {
      description = "Jira and Confluence from the terminal: TUI, CLI, Markdown sync and PDF/DOCX export";
      homepage = "https://atlcli.sh";
      changelog = "https://github.com/BjoernSchotte/atlcli/releases/tag/v${pins.version}";
      license = lib.licenses.asl20;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = lib.attrNames archives;
      mainProgram = "atlcli";
    };
  }
