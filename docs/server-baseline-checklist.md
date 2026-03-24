# Server Baseline Checklist

This checklist is for Debian and Ubuntu servers that:

- intentionally accept inbound traffic
- run a small number of defined services
- need tighter operational discipline than a normal workstation

This is not a generic benchmark. It is a practical server baseline.

## 1. Confirm the target fits this profile

This checklist is appropriate for:

- VPS instances
- web servers
- reverse proxies
- internal application hosts
- self-hosted services
- admin hosts that intentionally accept inbound SSH

This checklist is not the right baseline for:

- normal local-only desktops or laptops
- throwaway lab systems you do not care to maintain
- highly specialized appliance-like builds without adaptation

## 2. Confirm distro and environment

Check the system first:

```bash
cat /etc/os-release
uname -a
````

This repository is primarily written for Debian and Ubuntu systems using APT and systemd.

## 3. Update the system

```bash
sudo apt-get update
sudo apt-get upgrade
```

Do not harden a stale host and call it secure.

## 4. Identify what the server is supposed to do

Before touching the firewall or services, define the role of the server.

Examples:

* SSH only
* SSH and HTTPS
* reverse proxy
* database on an internal interface only
* application server behind another front end

If you cannot define the intended role clearly, you cannot harden it well.

## 5. Inspect live listening sockets

Before writing firewall rules:

```bash
ss -tulpen
```

Ask:

* what is listening
* on which address
* why is it exposed
* does it match the server’s actual role

This is one of the most important checks in the whole repo.

## 6. Apply a minimal firewall policy

Install UFW if needed:

```bash
sudo apt-get install ufw
```

Example baseline for a host that should expose SSH and HTTPS only:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

Verify:

```bash
sudo ufw status verbose
sudo ufw status numbered
ss -tulpen
```

Goal:

* only the intended inbound ports are allowed
* only the intended services are listening

## 7. Harden SSH safely

Review:

```text
docs/10-ssh-and-authentication.md
```

At minimum, confirm:

* root login is disabled
* empty passwords are not permitted
* key-based authentication is working
* password authentication is disabled when appropriate
* config was syntax-tested before reload
* a second real login was tested after changes

Do not harden SSH on a remote server without a rollback path.

## 8. Review enabled services

List enabled services:

```bash
systemctl list-unit-files --type=service --state=enabled
```

List running services:

```bash
systemctl list-units --type=service --state=running
```

Remove what is not needed:

```bash
sudo systemctl disable --now <service-name>
```

Verify with:

```bash
systemctl status <service-name>
ss -tulpen
```

A hardened server should look intentionally minimal, not cluttered.

## 9. Consider Fail2ban when services are exposed

If the server intentionally exposes SSH or another login surface, install Fail2ban:

```bash
sudo apt-get install fail2ban
sudo systemctl status fail2ban
```

Use only the jails that match the services you actually expose.

## 10. Review filesystem and mount posture

Inspect:

```bash
cat /etc/fstab
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS
```

High-value review points:

* `/tmp`
* `/var`
* `/home`
* removable or secondary mounts
* service-specific data paths

Do not apply `noexec`, `nosuid`, or `nodev` blindly. Match the mount options to the role of the host.

## 11. Review kernel-network posture

Inspect:

```bash
sysctl net.ipv4.conf.all.accept_source_route
sysctl net.ipv4.icmp_echo_ignore_broadcasts
sysctl net.ipv4.conf.all.accept_redirects
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
```

For normal servers that are not acting as routers, forwarding should usually not be enabled.

Persist intentional values under:

```text
/etc/sysctl.d/
```

## 12. Run a baseline audit

Install and run Lynis:

```bash
sudo apt-get install lynis
sudo lynis audit system
```

Use the results to identify weak defaults, stale packages, and unnecessary exposure.

## 13. Keep the role tight

A well-hardened server should have:

* a clearly defined role
* a very small allowed port set
* a very small service set
* predictable listening sockets
* explicit SSH policy
* current packages
* a sane rollback path for hardening changes

If the host is doing five unrelated jobs, fix that before pretending the hardening is finished.

## 14. Quick completion check

Before calling the server baseline complete, confirm:

1. packages were updated
2. the server role was defined
3. listening sockets were reviewed
4. UFW is enabled
5. inbound rules are minimal and justified
6. SSH was reviewed safely
7. enabled services were reviewed
8. unnecessary services were disabled
9. Fail2ban was considered where exposure exists
10. mounts were reviewed
11. kernel network posture was reviewed
12. Lynis was run

## Bottom line

A server baseline should be:

* narrow
* justified
* verifiable
* role-aware
* maintainable under pressure
