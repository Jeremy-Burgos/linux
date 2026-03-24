#!/usr/bin/env bash
#
# Example: endpoint-focused sysctl.d baseline for Debian/Ubuntu.
# Intended for workstations and admin hosts that are NOT routers.
#
# This script:
#   - writes /etc/sysctl.d/99-hardening.conf
#   - reloads systemd-sysctl
#   - verifies live values
#
# Do not use blindly on:
#   - routers
#   - VPN gateways
#   - Kubernetes/container networking hosts
#   - systems that intentionally forward traffic
#
# Review before running.
# Run with sudo.

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root or with sudo."
  exit 1
fi

CONF="/etc/sysctl.d/99-hardening.conf"

echo "[*] Writing ${CONF} ..."
cat > "${CONF}" <<'EOF'
# Endpoint-focused kernel network hardening
# Debian/Ubuntu local admin override

net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

net.ipv4.icmp_echo_ignore_broadcasts = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0

net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
EOF

echo "[*] Reloading systemd-sysctl..."
systemctl restart systemd-sysctl

echo "[*] Verifying live values..."
sysctl net.ipv4.conf.all.accept_source_route
sysctl net.ipv4.conf.default.accept_source_route
sysctl net.ipv4.icmp_echo_ignore_broadcasts
sysctl net.ipv4.conf.all.accept_redirects
sysctl net.ipv4.conf.default.accept_redirects
sysctl net.ipv4.conf.all.secure_redirects
sysctl net.ipv4.conf.default.secure_redirects
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
sysctl net.ipv4.conf.all.rp_filter
sysctl net.ipv4.conf.default.rp_filter

echo "[*] Done."
echo "[*] Confirm this host is not intended to route traffic before keeping these settings."