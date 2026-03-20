#!/usr/bin/env bash
#
# Example: collect service and socket visibility on Debian/Ubuntu.
# This script does NOT modify the system.
#
# It shows:
#   - enabled service units
#   - running service units
#   - socket units
#   - listening sockets
#
# Review output carefully before disabling anything.
# Run with or without sudo. Some socket/process details are richer with sudo.

set -euo pipefail

echo "[*] Enabled service units:"
systemctl list-unit-files --type=service --state=enabled

echo
echo "[*] Running service units:"
systemctl list-units --type=service --state=running

echo
echo "[*] Enabled socket units:"
systemctl list-unit-files --type=socket --state=enabled || true

echo
echo "[*] Active socket units:"
systemctl list-units --type=socket || true

echo
echo "[*] Listening sockets:"
ss -tulpen || true

echo
echo "[*] Review complete."
echo "[*] Compare enabled units, running units, and listening sockets before disabling anything."