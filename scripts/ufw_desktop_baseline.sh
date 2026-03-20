#!/usr/bin/env bash
#
# Example: Debian/Ubuntu workstation firewall baseline
# Applies:
#   - default deny incoming
#   - default allow outgoing
#   - enables UFW
# Then verifies with UFW status and ss.
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

echo "[*] Installing UFW..."
apt-get install -y ufw

echo "[*] Applying workstation firewall defaults..."
ufw default deny incoming
ufw default allow outgoing

echo "[*] Enabling UFW..."
ufw --force enable

echo "[*] UFW verbose status:"
ufw status verbose

echo "[*] UFW numbered rules:"
ufw status numbered

echo "[*] Listening sockets:"
ss -tulpen || true

echo "[*] Done."
echo "[*] Review the listening sockets above and remove any service exposure you do not need."