# Tested On

This repository is Linux-specific, but it is not distribution-agnostic.

It is primarily written for:

1. Debian
2. Ubuntu
3. Debian- or Ubuntu-derived systems that still use:
   1. APT
   2. systemd
   3. UFW
   4. AppArmor as the default mandatory access control framework

This file separates:

1. what the repository is aimed at
2. what should be treated as version-sensitive
3. what should be tested before being trusted

## Validation model used in this repository

Statuses used here:

1. Validated
2. Reviewed
3. Version-sensitive
4. Use with caution

Definitions:

## Validated

Directly tested in a real Debian or Ubuntu environment.

## Reviewed

Syntax and workflow reviewed against current Debian, Ubuntu, OpenSSH, or systemd behavior, but not personally field-tested in every scenario.

## Version-sensitive

May differ by release, package version, init system, or distro family.

## Use with caution

Can break access, networking, or service availability if applied carelessly.

## Current repository status

At this stage, the repository should be treated as:

1. Debian/Ubuntu-focused
2. systemd-focused
3. APT-focused
4. reviewed for current package and service behavior
5. use with caution for SSH, firewall, kernel tuning, filesystem mount changes, and mandatory access control changes

## Primary target platforms

## Debian

Status: Reviewed

Notes:

1. The repository maps well to Debian package and service behavior.
2. Debian OpenSSH packaging supports `/etc/ssh/sshd_config.d/`.
3. UFW, fail2ban, AppArmor, and Lynis all fit naturally here.

## Ubuntu

Status: Reviewed

Notes:

1. The repository maps well to Ubuntu server and desktop behavior.
2. systemd assumptions fit normally here.
3. AppArmor is the default mandatory access control path.
4. UFW and fail2ban guidance is directly relevant.

## Debian and Ubuntu derivatives

Status: Version-sensitive

Notes:

1. Many commands will still work.
2. Package names, defaults, or service names may drift.
3. Verify before assuming parity with Debian or Ubuntu proper.

## Platforms not treated as primary targets

These are not the main target for this repository without adaptation:

1. RHEL
2. CentOS Stream
3. Fedora
4. Arch
5. Alpine
6. OpenSUSE
7. non-systemd distributions

Reasons:

1. package manager differences
2. SELinux-first rather than AppArmor-first assumptions
3. firewall tooling differences
4. service-management differences
5. filesystem and policy defaults that do not match Debian/Ubuntu

## Areas that always require extra validation

The following should always be tested before applying them to a production system:

1. SSH hardening
2. firewall rules on remote systems
3. fail2ban on exposed hosts
4. kernel sysctl persistence
5. filesystem mount-option changes
6. disabling services at boot
7. AppArmor enforcement changes

## Honest operating assumption

This repository should be read as:

1. Debian/Ubuntu-first
2. workstation-and-small-server focused
3. operationally cautious
4. stronger than generic Linux notes, but not a universal Linux benchmark

## Maintenance rule

Before claiming a section is fully validated, confirm:

1. the command exists on the target distro
2. the package name is correct
3. the service name is correct
4. the state change can be verified
5. a rollback path exists
6. the guidance still matches the distro family the repo claims to support

## Suggested note format for future maintenance

When updating a section, record:

1. date reviewed
2. distro
3. release
4. whether behavior was validated or documentation-reviewed

Example:

1. 2026-03-13 — Debian 12 — Reviewed
2. 2026-03-13 — Ubuntu 24.04 — Reviewed
3. 2026-03-13 — Ubuntu 22.04 — Pending direct validation