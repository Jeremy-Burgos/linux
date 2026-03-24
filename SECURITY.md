# Security Policy

This repository contains Linux hardening guidance, example commands, and example scripts for Debian and Ubuntu systems.

It is not a managed security product, and it is not intended to be treated as a drop-in guarantee of safety.

## Supported Scope

This repository is primarily scoped to:

- Debian
- Ubuntu
- Debian- and Ubuntu-like systems using:
  - APT
  - systemd
  - UFW
  - AppArmor

The guidance and scripts are written for:

- workstations
- administrative endpoints
- small self-managed servers

They are not guaranteed to apply cleanly to:

- RHEL
- Fedora
- CentOS Stream
- Arch
- Alpine
- OpenSUSE
- non-systemd distributions

## What to Report

Please report issues that could cause users to make unsafe changes, including:

- incorrect commands
- unsafe defaults in example scripts
- misleading guidance that could expose services unintentionally
- steps that could lock users out of remote systems without proper warning
- documentation that materially misrepresents Debian or Ubuntu behavior

## What Not to Report

Please do not use this repository as a channel for:

- general Linux troubleshooting requests
- unsupported distro-specific issues outside the repository scope
- theoretical issues with no practical impact on the commands or workflows here
- requests for private security support

## Responsible Disclosure Expectations

If you believe a command, script, or workflow in this repository could lead to:

- unintended network exposure
- broken authentication
- weakened local hardening
- dangerous persistence or boot behavior

please report it privately first if possible.

Do not publish exploit-style writeups about repository mistakes before giving a reasonable chance to correct them.

## Important User Warning

Example scripts in this repository are intentionally conservative, but they are still examples.

Users should:

1. read every script before running it
2. test changes on non-production systems first
3. avoid applying remote-access-affecting changes without a rollback path
4. verify all state changes after applying them

## No Warranty

This repository is provided as documentation and example code.

You are responsible for:

- testing it
- validating it
- deciding whether it fits your system’s role
- maintaining rollback access