#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash

export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # shellcheck disable=SC1091
  . "$NVM_DIR/nvm.sh"
else
  echo "nvm was not installed at $NVM_DIR" >&2
  exit 1
fi

nvm install --lts
nvm alias default 'lts/*'
nvm use default

node --version
npm --version
