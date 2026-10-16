#!/usr/bin/env bash
# Re-pin pins.json to an atlcli release, the latest stable one by default.
#
# Every release ships a checksums.txt next to its archives, so the hashes come
# from there instead of downloading ~300 MiB of binaries.
set -euo pipefail

pins=${1:-atlcli/pins.json}
repo=BjoernSchotte/atlcli
tag=${2:-$(curl --fail --location --silent --show-error \
  "https://api.github.com/repos/$repo/releases/latest" | jq -r .tag_name)}

sums=$(curl --fail --location --silent --show-error \
  "https://github.com/$repo/releases/download/$tag/checksums.txt")

hashes='{}'
for platform in linux-x64 linux-arm64 darwin-x64 darwin-arm64; do
  sha=$(awk -v f="atlcli-$platform.tar.gz" '$2 == f { print $1 }' <<<"$sums")
  if [[ -z $sha ]]; then
    echo "$tag has no checksum for atlcli-$platform.tar.gz" >&2
    exit 1
  fi
  hashes=$(jq --arg p "$platform" --arg s "$sha" '.[$p] = $s' <<<"$hashes")
done

jq -n --arg v "${tag#v}" --argjson h "$hashes" \
  '{version: $v, sha256: $h}' >"$pins.tmp"
mv "$pins.tmp" "$pins"

echo "pinned atlcli ${tag#v} -> $pins" >&2
