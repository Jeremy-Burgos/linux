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

## Start here

Read these files first:

- [QUICKSTART.md](QUICKSTART.md)
- [THREAT_MODEL.md](THREAT_MODEL.md)
- [TESTED_ON.md](TESTED_ON.md)
- [SECURITY.md](SECURITY.md)
- [CHANGELOG.md](CHANGELOG.md)

Then move into the numbered guides under `docs/`.

## Quick start

Clone the repository:

```bash
git clone https://github.com/Jeremy-Burgos/linux.git
cd linux
````

Open the overview:

```bash
less docs/00-overview.md
```

Good first sections to review:

* [docs/06-firewall-and-networking.md](docs/06-firewall-and-networking.md)
* [docs/09-services-and-boot-hardening.md](docs/09-services-and-boot-hardening.md)
* [docs/10-ssh-and-authentication.md](docs/10-ssh-and-authentication.md)
* [docs/11-kernel-tuning.md](docs/11-kernel-tuning.md)

The scripts under `scripts/` are examples only. Read them before running them.

## Repository structure

```text
linux/
├── README.md
├── QUICKSTART.md
├── CHANGELOG.md
├── LICENSE
├── SECURITY.md
├── TESTED_ON.md
├── THREAT_MODEL.md
├── .editorconfig
├── .markdownlint.json
├── docs/
└── scripts/
```

## Suggested reading paths

### Workstation baseline

Start with:

* [QUICKSTART.md](QUICKSTART.md)
* [docs/06-firewall-and-networking.md](docs/06-firewall-and-networking.md)
* [docs/07-system-auditing-and-lynis.md](docs/07-system-auditing-and-lynis.md)
* [docs/09-services-and-boot-hardening.md](docs/09-services-and-boot-hardening.md)
* [docs/11-kernel-tuning.md](docs/11-kernel-tuning.md)
* [docs/workstation-baseline-checklist.md](docs/workstation-baseline-checklist.md)

### Server baseline

Start with:

* [QUICKSTART.md](QUICKSTART.md)
* [docs/06-firewall-and-networking.md](docs/06-firewall-and-networking.md)
* [docs/09-services-and-boot-hardening.md](docs/09-services-and-boot-hardening.md)
* [docs/10-ssh-and-authentication.md](docs/10-ssh-and-authentication.md)
* [docs/11-kernel-tuning.md](docs/11-kernel-tuning.md)
* [docs/13-fail2ban.md](docs/13-fail2ban.md)
* [docs/server-baseline-checklist.md](docs/server-baseline-checklist.md)

## Philosophy

Core assumptions:

1. Linux defaults are not automatically secure enough.
2. Fewer enabled services means fewer mistakes and fewer attack paths.
3. Visibility matters as much as blocking.
4. Verification matters more than checklist hardening.
5. Workstations and internet-facing servers should not be hardened the same way.

## Scripts

Example scripts live under:

```text
scripts/
```

They are examples, not blind hardening wrappers.

Included examples:

* `ufw_desktop_baseline.sh`
* `fail2ban_sshd_example.sh`
* `sysctl_endpoint_baseline.sh`
* `service_review.sh`

## Disclaimer

Some controls in this repository can:

* break connectivity
* disable services you still need
* lock you out of remote systems
* interfere with role-specific workloads

Test everything before applying it to production, remote hosts, or primary machines.

## About

A practical, Debian/Ubuntu-focused Linux hardening repository for people who want visibility, verification, and a cleaner workstation or server baseline without blind automation.
