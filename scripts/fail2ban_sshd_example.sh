#!/usr/bin/env bash
#
# Example: minimal Fail2ban SSH jail using .local overrides.
# Intended for Debian/Ubuntu hosts that intentionally expose SSH.
#
# This script:
#   - installs fail2ban
#   - writes /etc/fail2ban/jail.local
#   - uses a UFW banaction
#   - enables the sshd jail
#   - restarts fail2ban
#   - shows jail status
#
# Review before running.
# Run with sudo.

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root or with sudo."
  exit 1
fi

echo "[*] Updating package metadata..."
apt-get update

echo "[*] Installing fail2ban..."
apt-get install -y fail2ban

echo "[*] Writing /etc/fail2ban/jail.local ..."
cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
banaction = ufw
bantime   = 1h
findtime  = 10m
maxretry  = 5

[sshd]
enabled = true
EOF

echo "[*] Restarting fail2ban..."
systemctl restart fail2ban

echo "[*] Fail2ban service status:"
systemctl --no-pager --full status fail2ban || true

echo "[*] Overall jail status:"
fail2ban-client status || true

echo "[*] SSH jail status:"
fail2ban-client status sshd || true

echo "[*] UFW rules:"
ufw status numbered || true

echo "[*] Done."
echo "[*] Confirm this host actually needs inbound SSH before keeping this jail enabled."