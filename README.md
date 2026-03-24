# Linux Privacy & Hardening Toolkit

A practical, Debian/Ubuntu-focused hardening repository for people who want visibility, verification, and sane operational security without blind automation.

This project is designed for:

- privacy-conscious Linux users
- defenders and researchers
- administrators who want a cleaner baseline
- users who prefer explicit control over defaults

This repository is not a one-click hardening script.

It is a structured set of guides, checklists, and example scripts for building a tighter Debian or Ubuntu workstation or small server baseline.

## Scope

This repository covers:

- core Linux command-line literacy
- process inspection and filtering
- file and directory handling
- APT-based package management
- kernel and module inspection
- firewalling with UFW
- auditing with Lynis
- filesystem hardening
- service minimization
- SSH hardening
- kernel tuning with `sysctl.d`
- AppArmor and SELinux context
- Fail2ban for exposed services
- role-based workstation and server baselines

Primary target:

- Debian
- Ubuntu
- Debian- and Ubuntu-like systems using APT and systemd

This repository is not written as a generic guide for every Linux distribution.

## Philosophy

Core assumptions:

1. Linux defaults are not automatically secure enough.
2. Fewer enabled services means fewer mistakes and fewer attack paths.
3. Visibility matters as much as blocking.
4. Verification matters more than checklist hardening.
5. Workstations and internet-facing servers should not be hardened the same way.

## Quick start

Clone the repository:

```bash
git clone https://github.com/Jeremy-Burgos/linux.git
cd linux
````

Start here:

```bash
less docs/00-overview.md
```

Then read:

```text
QUICKSTART.md
THREAT_MODEL.md
TESTED_ON.md
```

## Suggested reading order

For most users:

1. `QUICKSTART.md`
2. `THREAT_MODEL.md`
3. `docs/06-firewall-and-networking.md`
4. `docs/09-services-and-boot-hardening.md`
5. `docs/10-ssh-and-authentication.md`
6. `docs/11-kernel-tuning.md`

## Scripts

Example scripts live under:

```text
scripts/
```

They are examples, not blind hardening wrappers.

Read them before running them.

## Disclaimer

Some controls in this repository can:

* break connectivity
* disable services you still need
* lock you out of remote systems
* interfere with role-specific workloads

Test everything before applying it to production, remote hosts, or primary machines.

## About

A practical, CIS-aligned Linux hardening toolkit for Debian and Ubuntu systems, focused on visibility, least privilege, firewalling, mandatory access control, auditing, and defending everyday workstations and servers without blind automation.
