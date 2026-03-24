# Scripts

These scripts are examples, not blind hardening wrappers.

They are intentionally conservative and are meant to support the documentation in this repository.

## Principles

1. Read the script before running it.
2. Run scripts only on Debian/Ubuntu-like systems you understand.
3. Do not run remote-access-affecting scripts on a remote host without a rollback path.
4. Treat endpoint baselines and server baselines as different things.

## Included scripts

### `ufw_desktop_baseline.sh`

Applies a simple workstation firewall profile:

- deny incoming
- allow outgoing
- enable UFW
- show UFW state
- show listening sockets

### `fail2ban_sshd_example.sh`

Creates a minimal Fail2ban SSH jail example using `.local` overrides and a UFW ban action, then restarts Fail2ban and shows status.

Use only on systems that intentionally expose SSH.

### `sysctl_endpoint_baseline.sh`

Writes an endpoint-focused `sysctl.d` profile and reloads `systemd-sysctl`.

Do not use on routers, VPN gateways, or systems that intentionally forward traffic.

### `service_review.sh`

Collects service and socket visibility for review:

- enabled service units
- running service units
- socket units
- listening network sockets

This is a visibility script, not a remediation script.

## Usage

Make scripts executable:

```bash
chmod +x scripts/*.sh
````

Run explicitly:

```bash
sudo ./scripts/ufw_desktop_baseline.sh
sudo ./scripts/service_review.sh
```

Only use the Fail2ban and sysctl scripts on systems where the role of the machine is clear.