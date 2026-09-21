# soloist

Nix packaging for [Spotify Soloist](https://developer.spotify.com/documentation/soloist),
a headless Spotify Connect player with a CLI and a WebSocket API.

Spotify publishes no source and no nixpkgs package, only prebuilt Linux
archives, so this flake fetches the official archive for the host architecture
and patches it for the store.

## Outputs

| Output | What it is |
| --- | --- |
| `packages.<system>.soloist` | The patched daemon (`soloist`, which also provides `soloist ctl`) |
| `packages.<system>.update` | Script that re-pins every architecture |
| `overlays.default` | Adds `pkgs.soloist` |
| `nixosModules.default` | System service, `services.soloist` |
| `homeModules.default` | home-manager user service, `services.soloist` |

Systems: `x86_64-linux`, `aarch64-linux`, `armv7l-linux`. **There is no macOS
build**, so darwin hosts cannot run Soloist at all — not even `soloist ctl`,
which is a subcommand of the same binary.

## Use

```nix
{
  inputs.soloist.url = "github:you/dotfiles?dir=soloist";

  # NixOS, as a system daemon
  modules = [inputs.soloist.nixosModules.default];

  # or home-manager, as a user service
  home-manager.sharedModules = [inputs.soloist.homeModules.default];
}
```

```nix
services.soloist = {
  enable = true;
  deviceName = "Living room";
  apiKeyFile = "/etc/soloist/api-key";
  websocket.enable = true;
};
```

The package is unfree (prebuilt, and Spotify forbids redistributing the
archives), so consumers need `nixpkgs.config.allowUnfree = true`, or
`NIXPKGS_ALLOW_UNFREE=1 nix build --impure` outside a system config.

## API key

Generate one at <https://developer.spotify.com/dashboard/soloist> — it needs
Spotify Premium. The modules take it one of two ways, exactly one of which must
be set.

From a file, handed to the unit through systemd's credential store:

```nix
services.soloist.apiKeyFile = "/etc/soloist/api-key";
```

```
install -Dm600 /dev/stdin /etc/soloist/api-key <<< "$KEY"
```

Or from a command, for keys kept in a password manager:

```nix
services.soloist.apiKeyCommand = [(lib.getExe pkgs.pass) "soloist"];
```

The command runs inside the unit, so whatever it needs has to be reachable
from there. With `pass` that means gpg-agent already holding the key: a
terminal pinentry cannot prompt from a unit, so the service fails and retries
until the agent is unlocked.

Either way the key stays out of the Nix store. Upstream accepts it only as an
argv flag, so it is visible in the running process' command line regardless.

Pair the device once before the daemon is useful:

```
soloist --pair --device-name "Living room" --api-key "$(pass soloist)"
```

## Updating

Two separate reasons to re-pin, both unavoidable:

- The download URLs are unversioned (`soloist_release_<arch>.tar.gz`) and
  Spotify rebuilds them in place, so a pinned hash stops resolving without
  warning. The build breaks until the pins are refreshed.
- **Builds expire 90 days after their build date** and then exit with code
  `10`. The current pin is in `pins.json` under `expires`.

```
nix run .#update            # rewrites soloist/pins.json
nix run .#update -- pins.json
```

The archives carry no version string and their tar mtimes are zeroed, so the
build stamp comes from the CDN's `Last-Modified` header and the release number
from the bundled `CHANGELOG.md`.
