# Workstation Baseline Checklist

This checklist is for Debian and Ubuntu workstations that:

- are used locally
- do not intentionally expose services to the internet
- are meant to be understandable, maintainable, and low-noise

This is not a full benchmark. It is a practical baseline.

## 1. Confirm the target fits this profile

This checklist is appropriate for:

- laptops
- desktops
- developer workstations
- research systems used locally
- personal Debian or Ubuntu machines

This checklist is not the right starting point for:

- VPS systems
- internet-facing hosts
- public web servers
- machines that must accept inbound SSH or app traffic as part of their role

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

Patch lag is one of the easiest ways to lose ground.

## 4. Enable a simple host firewall baseline

Install UFW if needed:

```bash
sudo apt-get install ufw
```

Apply workstation defaults:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

Verify:

```bash
sudo ufw status verbose
sudo ufw status numbered
ss -tulpen
```

Goal:

* inbound denied by default
* outbound allowed by default
* no unexplained listeners

## 5. Review enabled and running services

Review what starts at boot:

```bash
systemctl list-unit-files --type=service --state=enabled
```

Review what is running now:

```bash
systemctl list-units --type=service --state=running
```

Review listening sockets:

```bash
ss -tulpen
```

Ask:

* does this workstation need this service
* why is it enabled
* why is it listening
* is it a leftover from testing or package installation

## 6. Run a baseline audit

Install and run Lynis:

```bash
sudo apt-get install lynis
sudo lynis audit system
```

Use Lynis to identify obvious gaps, not to chase cosmetic scores.

## 7. Review AppArmor on Debian/Ubuntu

Check status:

```bash
sudo aa-status
```

If missing:

```bash
sudo apt-get install apparmor apparmor-utils
```

Goal:

* confirm AppArmor is present
* understand which profiles are enforcing
* do not disable it casually

## 8. Review SSH exposure

Check whether anything is listening on port 22:

```bash
ss -tulpen | grep ':22'
```

If the workstation does not need to accept inbound SSH, there should be a clear reason if SSH is present.

## 9. Review filesystem mount posture

Inspect persistent mounts:

```bash
cat /etc/fstab
```

Inspect live mounts:

```bash
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS
```

High-value review points:

* `/tmp`
* `/home`
* removable media
* any unusual writable mount points

## 10. Review kernel-network baseline

Inspect key values:

```bash
sysctl net.ipv4.conf.all.accept_source_route
sysctl net.ipv4.icmp_echo_ignore_broadcasts
sysctl net.ipv4.conf.all.accept_redirects
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
```

A normal workstation should not be behaving like a router.

## 11. Keep the machine explainable

A well-hardened workstation should have:

* a small set of enabled services
* a small set of listening sockets
* clear firewall defaults
* a current package state
* no unexplained admin or server components

If you cannot explain why a service is there, that is the next thing to investigate.

## 12. Quick completion check

Before calling the workstation baseline complete, confirm:

1. packages were updated
2. UFW is enabled
3. incoming is denied by default
4. listening sockets were reviewed
5. enabled services were reviewed
6. Lynis was run
7. AppArmor was checked
8. SSH exposure was reviewed
9. filesystem mounts were reviewed
10. kernel network basics were reviewed

## Bottom line

A workstation baseline should be:

* minimal
* understandable
* low-noise
* easy to verify
* easy to maintain
