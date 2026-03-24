# Threat Model

This repository is not built around a single generic Linux profile.

Linux hardening only makes sense when it is tied to:

1. what you are protecting
2. what you are protecting it from
3. how much convenience you are willing to give up
4. whether the system is a workstation, admin box, or exposed server

This document defines the threat-model assumptions behind the repository.

## What this repository is optimized for

This repository is primarily optimized for:

1. Debian and Ubuntu workstations
2. Debian and Ubuntu admin systems
3. small self-managed servers
4. users who want explicit visibility and explicit control
5. people who are willing to verify changes rather than blindly apply them

It is not optimized for:

1. generic Linux advice across every distribution
2. enterprise fleet management at scale
3. users who want a one-click hardening script
4. environments where convenience is always more important than security
5. users who are unwilling to test and roll back changes safely

## Threat categories considered

## 1. Commodity attacks and internet noise

Examples:

1. opportunistic scanning
2. brute-force login attempts
3. exposed services with weak defaults
4. stale packages and old vulnerabilities
5. low-effort malware and malicious scripts

Relevant sections:

1. package management
2. firewall and networking
3. fail2ban
4. SSH hardening
5. service minimization

## 2. Misconfiguration and unnecessary exposure

Examples:

1. too many enabled services
2. bad `sshd_config` settings
3. IP forwarding left on unintentionally
4. permissive filesystem mount options
5. forgotten test services still listening

Relevant sections:

1. services and boot hardening
2. SSH and authentication
3. kernel tuning
4. filesystems and partitions
5. process and network inspection

## 3. Persistence and post-compromise abuse

Examples:

1. unauthorized services enabled at boot
2. malicious or unexpected cron jobs, timers, or helpers
3. abuse of weak local permissions
4. use of exposed forwarding and tunneling
5. local privilege escalation aided by weak system posture

Relevant sections:

1. services and boot hardening
2. kernel and modules
3. AppArmor
4. filesystem mount controls
5. system auditing

## 4. Administrative mistakes

Examples:

1. locking yourself out of SSH
2. deleting the wrong firewall rule
3. breaking a service by applying a hardening change without testing
4. applying server guidance to a desktop
5. copying controls from the wrong distro family

Relevant sections:

1. quickstart
2. tested-on notes
3. SSH and authentication
4. firewall and networking
5. mandatory access control

## Suggested profiles

## Profile 1: Desktop baseline

Best for:

1. personal Linux systems
2. developer workstations
3. general-purpose Debian or Ubuntu desktops
4. laptops and local-only machines

Prioritize:

1. package updates
2. UFW with deny incoming and allow outgoing
3. Lynis auditing
4. AppArmor review on Debian/Ubuntu
5. basic service minimization
6. kernel network sanity checks
7. filesystem review where practical

Tradeoff:

1. low to moderate friction

## Profile 2: Administrative workstation

Best for:

1. security-conscious users
2. administrators
3. researchers
4. systems used to access other infrastructure

Prioritize everything in Desktop baseline, plus:

1. stronger SSH client and server discipline
2. more aggressive service review
3. fail2ban where exposed services exist
4. explicit kernel tuning persistence
5. mount option review and cleanup
6. regular Lynis review

Tradeoff:

1. moderate friction
2. more maintenance
3. more chance of breaking convenience features

## Profile 3: Internet-facing server

Best for:

1. VPS instances
2. home lab servers exposed to the internet
3. self-hosted services
4. admin endpoints that intentionally accept inbound connections

Prioritize everything in Administrative workstation, plus:

1. strict SSH hardening
2. fail2ban for exposed services
3. service minimization
4. explicit review of listening ports
5. tighter firewall policy
6. stronger authentication and account discipline
7. careful update hygiene

Tradeoff:

1. higher risk if misconfigured
2. higher verification burden
3. greater need for rollback planning

## What this repository does not try to do

This repository does not try to be:

1. a universal Linux benchmark for every distro
2. a replacement for distro-specific documentation
3. a one-click “secure Linux” script
4. a full incident-response manual
5. a guarantee against compromise

## Core philosophy

The assumptions behind this repository are simple:

1. Linux defaults are not automatically “secure enough.”
2. Fewer exposed services means fewer mistakes and fewer attack paths.
3. Verification matters more than hardening theater.
4. A workstation and a public server should not be treated the same way.
5. Every control should have a reason, a verification step, and a rollback path.

If you cannot explain a hardening change, verify it, and safely undo it, you should not apply it casually.