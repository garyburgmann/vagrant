#!/usr/bin/env bash
set -euo pipefail

key_path="${SSH_KEY_PATH:-$HOME/.ssh/id_rsa}"
key_comment="${SSH_KEY_COMMENT:-$USER@$(hostname)}"

mkdir -p "$(dirname "$key_path")"
chmod 700 "$(dirname "$key_path")"

if [[ -e "$key_path" ]]; then
  echo "SSH key already exists at $key_path; leaving it unchanged."
  exit 0
fi

ssh-keygen -t rsa -b 4096 -N "" -f "$key_path" -C "$key_comment"
chmod 600 "$key_path"
chmod 644 "${key_path}.pub"
