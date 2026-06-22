#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if command -v VBoxService >/dev/null && systemctl list-unit-files vboxadd-service.service >/dev/null 2>&1; then
  # In VirtualBox guests, host time sync survives laptop sleep/resume better than
  # systemd-timesyncd. The stock vboxadd service conflicts with timesyncd, so
  # make that choice explicit and force a set on service start/VM restore.
  systemctl disable --now systemd-timesyncd.service 2>/dev/null || true
  systemctl mask systemd-timesyncd.service 2>/dev/null || true

  install -m 0755 -d /etc/systemd/system/vboxadd-service.service.d
  cat >/etc/systemd/system/vboxadd-service.service.d/10-timesync.conf <<'EOF'
[Unit]
Conflicts=
Conflicts=shutdown.target

[Service]
ExecStart=
ExecStart=/usr/sbin/VBoxService --pidfile /var/run/vboxadd-service.sh --timesync-set-start --timesync-set-on-restore --timesync-set-threshold 1000 --timesync-interval 10000
PIDFile=/var/run/vboxadd-service.sh
GuessMainPID=yes
RemainAfterExit=no
Restart=always
RestartSec=5s
EOF

  systemctl daemon-reload
  systemctl enable --now vboxadd.service
  systemctl enable --now vboxadd-service.service
  systemctl restart vboxadd-service.service

  sleep 2
  date -Is
  pgrep -a VBoxService
  exit 0
fi

# Fallback for non-VirtualBox guests.
apt-get update
apt-get install -y chrony

cat >/etc/chrony/chrony.conf <<'EOF'
pool ntp.ubuntu.com iburst
pool time.cloudflare.com iburst
pool time.google.com iburst

makestep 1 -1
rtcsync

keyfile /etc/chrony/chrony.keys
driftfile /var/lib/chrony/chrony.drift
logdir /var/log/chrony
EOF

systemctl disable --now systemd-timesyncd.service 2>/dev/null || true
systemctl enable --now chrony.service
chronyc -a 'burst 4/4' makestep || true
date -Is
