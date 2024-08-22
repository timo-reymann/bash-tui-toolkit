#!/usr/bin/env bash
set -eo pipefail

release_tag="$1"
if [[ -z "$release_tag" ]]; then
  echo "Usage: $0 <release_tag>"
  exit 1
fi

tmp_folder="$(mktemp -d)"
echo "Created folder $tmp_folder ..."
cd "${tmp_folder}"

echo "Clone gh-pages branch ..."
git clone https://github.com/timo-reymann/bash-tui-toolkit.git --branch gh-pages "${tmp_folder}"

echo "Create folder for version ..."
mkdir -p "${release_tag}"

release_info=$(curl --header "Authorization: Bearer ${GITHUB_TOKEN}" -s "https://api.github.com/repos/timo-reymann/bash-tui-toolkit/releases/tags/${release_tag}")
release_id="$(jq -r '.id' <<< "$release_info")"
release_assets="$(curl --header "Authorization: Bearer ${GITHUB_TOKEN}"  -s "https://api.github.com/repos/timo-reymann/bash-tui-toolkit/releases/${release_id}")"
asset_download_links="$(jq -r ".assets[].browser_download_url" <<< "$release_assets")"

cd "${release_tag}"
while read -r download_url
do
  echo "Download asset from ${download_url} ..."
  curl -sS -L "${download_url}" -O
done <<< "${asset_download_links}"
cd -

echo "Link ${release_tag} to latest ..."
rm latest || true
ln -s "${release_tag}" latest

git stage .
git commit -m "chore: Add assets for ${release_tag}\

[skip ci]
"

git push
