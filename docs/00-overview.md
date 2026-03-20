# 00 – Overview

This repository is a practical Linux hardening guide for Debian and Ubuntu systems.

It is written for people who want a system that is:

- easier to understand
- easier to verify
- harder to expose accidentally
- more disciplined about services, networking, and authentication

This repository is organized around a simple idea:

hardening should be role-aware, explicit, and testable.

## What this repository is trying to do

This repository helps you:

1. inspect what a Linux system is doing
2. reduce unnecessary exposure
3. tighten network, service, and authentication posture
4. build a cleaner workstation or server baseline
5. verify changes instead of assuming they worked

## What this repository is not trying to do

This repository is not:

- a universal benchmark for every Linux distribution
- a replacement for distro-specific documentation
- a compliance framework
- a one-click “secure Linux” script
- a guarantee against compromise

## Repository layout

The repository is structured into numbered documents so that the flow is deliberate.

The main progression is:

1. basics and navigation
2. process and file visibility
3. package and kernel awareness
4. firewalling and auditing
5. filesystems, services, and SSH hardening
6. kernel tuning and access-control context
7. Fail2ban and baseline checklists

At the root of the repository, these files matter first:

- [`QUICKSTART.md`](QUICKSTART.md)
- [`THREAT_MODEL.md`](THREAT_MODEL.md)
- [`TESTED_ON.md`](TESTED_ON.md)

## Recommended use

Read this repository in one of two ways.

### Workstation path

Best for:

- personal Debian or Ubuntu machines
- laptops
- desktops
- admin workstations

Start with:

- [`QUICKSTART.md`](QUICKSTART.md)
- [`docs/06-firewall-and-networking.md`](docs/06-firewall-and-networking.md)
- [`docs/09-services-and-boot-hardening.md`](`docs09-services-and-boot-hardening.md)
- [`docs/11-kernel-tuning.md`](docs/11-kernel-tuning.md)
- [`docs/workstation-baseline-checklist.md`](docs/workstation-baseline-checklist.md)

### Server path

Best for:

- VPS systems
- self-hosted services
- internet-facing admin boxes

Start with:

- [`QUICKSTART.md`](QUICKSTART.md)
- [`docs/06-firewall-and-networking.md`](docs/06-firewall-and-networking.md)
- [`docs/09-services-and-boot-hardening.md`](docs/09-services-and-boot-hardening.md)
- [`docs/10-ssh-and-authentication.md`](docs/10-ssh-and-authentication.md)
- [`docs/13-fail2ban.md`](docs/13-fail2ban.md)
- [`docs/server-baseline-checklist.md`](docs/server-baseline-checklist.md)

## First principles

Everything in this repository should be interpreted through these rules:

1. Know the role of the machine.
2. Know what is listening.
3. Know what starts at boot.
4. Know what packages and services are still necessary.
5. Verify every major change after applying it.
6. Keep a rollback path for remote or high-impact changes.

## Bottom line

A good hardening baseline is not the one with the most controls.

It is the one you can explain, verify, and maintain.