#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor --batch --yes -o /etc/apt/keyrings/microsoft.gpg
chmod go+r /etc/apt/keyrings/microsoft.gpg

write_azure_cli_source() {
  local suite="$1"

  cat >/etc/apt/sources.list.d/azure-cli.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${suite}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/microsoft.gpg
EOF
}

suite="${AZ_REPO:-$(lsb_release -cs)}"
write_azure_cli_source "$suite"

if ! apt-get update; then
  if [[ -n "${AZ_REPO:-}" || "$suite" == "noble" ]]; then
    exit 1
  fi

  echo "Azure CLI repository for '$suite' is not available; falling back to Ubuntu 24.04 'noble'."
  write_azure_cli_source "noble"
  apt-get update
fi

candidate="$(apt-cache policy azure-cli | awk '/Candidate:/ {print $2}')"
if [[ "$candidate" == "(none)" && -z "${AZ_REPO:-}" && "$suite" != "noble" ]]; then
  echo "No Azure CLI package candidate for '$suite'; falling back to Ubuntu 24.04 'noble'."
  write_azure_cli_source "noble"
  apt-get update
fi

apt-get install -y azure-cli
az version
