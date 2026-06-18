#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

HELM_BUILDKITE_APT_KEY_ID="DDF78C3E6EBB2D2CC223C95C62BA89D07698DBC6"

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
  -o "$tmp_dir/helm.gpg"

fingerprint="$(
  gpg --show-keys --with-colons "$tmp_dir/helm.gpg" |
    awk -F: '$1 == "fpr" {print $10}' |
    head -n 1
)"

if [[ "$fingerprint" != "$HELM_BUILDKITE_APT_KEY_ID" ]]; then
  echo "Unexpected Helm APT key fingerprint: $fingerprint" >&2
  exit 1
fi

gpg --dearmor --batch --yes \
  -o /usr/share/keyrings/helm.gpg \
  "$tmp_dir/helm.gpg"
chmod a+r /usr/share/keyrings/helm.gpg

cat >/etc/apt/sources.list.d/helm-stable-debian.list <<'EOF'
deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main
EOF
chmod a+r /etc/apt/sources.list.d/helm-stable-debian.list

apt-get update
apt-get install -y helm

helm version
