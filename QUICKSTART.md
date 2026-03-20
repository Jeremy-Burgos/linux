# Quickstart

This repository is not meant to be applied all at once.

Use this file to choose a sane starting point based on the role of the system.

First, confirm what you are actually running:

```bash
cat /etc/os-release
uname -a
````

This repository is primarily written for Debian and Ubuntu systems using APT and systemd.

## 1. Workstation baseline

Use this path for:

1. personal desktops
2. laptops
3. developer workstations
4. general-purpose Linux systems that do not intentionally expose services to the internet

## Step 1: update packages

```bash
sudo apt-get update
sudo apt-get upgrade
```

## Step 2: install and enable UFW

```bash
sudo apt-get install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status verbose
```

## Step 3: install and run Lynis

```bash
sudo apt-get install lynis
sudo lynis audit system
```

## Step 4: review enabled services

```bash
systemctl list-unit-files --state=enabled
ss -tulpen
```

Look for anything you do not need.

## Step 5: review kernel network basics

```bash
cat /proc/sys/net/ipv4/conf/all/accept_source_route
cat /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
cat /proc/sys/net/ipv4/ip_forward
cat /proc/sys/net/ipv6/conf/all/forwarding
```

## Step 6: review AppArmor status on Debian/Ubuntu

```bash
sudo aa-status
```

If AppArmor tooling is missing:

```bash
sudo apt-get install apparmor apparmor-utils
```

## 2. Administrative workstation baseline

Use this path for:

1. systems used to administer other systems
2. security research systems
3. machines that should be tighter than a normal desktop

Do everything in the workstation baseline, then add:

## Step 1: review SSH client and server exposure

If the machine does not need to accept inbound SSH, confirm nothing is listening:

```bash
ss -tulpen | grep ':22'
```

If SSH server is installed intentionally, move to the server baseline below.

## Step 2: review filesystem mounts

```bash
cat /etc/fstab
findmnt
```

Review whether `/tmp`, `/var`, `/home`, `/opt`, and removable-media mounts can be hardened further.

## Step 3: review loaded kernel modules

```bash
lsmod
modinfo <module-name>
```

Do not unload modules casually on a system you rely on unless you know the dependency chain.

## Step 4: perform a second Lynis pass after changes

```bash
sudo lynis audit system
```

## 3. Internet-facing server baseline

Use this path for:

1. VPS hosts
2. home lab services intentionally exposed to the internet
3. boxes that must accept inbound connections such as SSH or HTTPS

This profile requires more caution because mistakes can lock you out.

## Step 1: update packages

```bash
sudo apt-get update
sudo apt-get upgrade
```

## Step 2: verify what is listening

```bash
ss -tulpen
```

If a service is listening and you did not mean to expose it, fix that before doing anything else.

## Step 3: apply firewall policy deliberately

For example, if the server is intended to expose SSH and HTTPS only:

```bash
sudo apt-get install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 443/tcp
sudo ufw enable
sudo ufw status verbose
```

Do not open ports you cannot justify.

## Step 4: harden SSH

Use the SSH guide in:

```text
docs/10-ssh-and-authentication.md
```

Do not edit SSH remotely without:

1. a backup
2. a second session open
3. a syntax check before reload
4. a tested rollback path

## Step 5: install fail2ban if services are exposed

```bash
sudo apt-get install fail2ban
sudo systemctl status fail2ban
```

Then configure only the jails that match the services you actually expose.

## Step 6: review enabled services and remove what is not needed

```bash
systemctl list-unit-files --state=enabled
```

Common examples to review:

1. web servers you are not using
2. database servers you forgot were installed
3. file-sharing services
4. old admin tools
5. test software left behind from setup

## 4. First principles

Regardless of profile, keep these rules in mind:

1. do not apply server guidance to a desktop without a reason
2. do not apply desktop assumptions to an exposed server
3. do not enable a service just because a guide mentions it
4. do not harden remotely without a rollback plan
5. verify every major change after you make it

## 5. Suggested first read order

For most users:

1. [`docs/00-overview.md`](docs/00-overview.md)
2. [`docs/06-firewall-and-networking.md`](docs/06-firewall-and-networking.md)
3. [`docs/07-system-auditing-and-lynis.md`](docs/07-system-auditing-and-lynis.md)
4. [`docs/09-services-and-boot-hardening.md`](docs/09-services-and-boot-hardening.md)
5. [`docs/10-ssh-and-authentication.md`](docs/10-ssh-and-authentication.md)
6. [`docs/11-kernel-tuning.md`](docs/11-kernel-tuning.md)
