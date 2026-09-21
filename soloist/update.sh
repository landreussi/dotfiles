#!/usr/bin/env bash
# Refresh pins.json against Spotify's CDN.
#
# The download URLs are unversioned and Spotify rebuilds them, so a pinned
# hash goes stale without warning. Builds also stop running 90 days after they
# were made, so this has to be run periodically regardless.
set -euo pipefail

pins=${1:-soloist/pins.json}
base=https://soloist-builds.spotifycdn.com

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

archives='{}'
for arch in x86_64 arm64 arm32; do
  url="$base/soloist_release_$arch.tar.gz"
  echo "fetching $arch" >&2
  curl --fail --location --silent --show-error -o "$tmp/$arch.tar.gz" "$url"
  sha=$(sha256sum "$tmp/$arch.tar.gz" | cut -d' ' -f1)

  # The archives carry no version and their tar mtimes are zeroed, so the CDN's
  # Last-Modified header is the only build stamp available without running a
  # possibly foreign-arch binary.
  modified=$(curl --fail --location --silent --show-error --head "$url" |
    sed -n 's/^[Ll]ast-[Mm]odified: //p' | tr -d '\r')
  build=$(date -u -d "$modified" +%Y%m%d)
  expires=$(date -u -d "$modified +90 days" +%Y-%m-%d)

  archives=$(jq \
    --arg a "$arch" --arg u "$url" --arg s "$sha" --arg b "$build" --arg e "$expires" \
    '.[$a] = {url: $u, sha256: $s, build: $b, expires: $e}' <<<"$archives")
done

release=$(tar -xzOf "$tmp/x86_64.tar.gz" CHANGELOG.md |
  sed -n 's/^## Release v//p' | head -n1)

jq -n --arg r "$release" --argjson a "$archives" \
  '{release: $r, archives: $a}' >"$tmp/pins.json"
mv "$tmp/pins.json" "$pins"

echo "pinned soloist $release (expires $(jq -r '.archives.x86_64.expires' "$pins")) -> $pins" >&2
