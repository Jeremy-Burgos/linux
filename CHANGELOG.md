# Changelog

All notable changes to this repository should be documented
in this file.

The format is based on a simple keep-a-log approach, with
versioned entries and brief summaries of what changed.

## [0.1.0] - 2026-03-13

### Added

- initial Linux privacy and hardening repository structure
- `README.md`
- `docs/00-overview.md`
- `docs/01-linux-basics-and-navigation.md`
- `docs/02-processes-and-searching.md`
- `docs/03-files-and-directories.md`
- `docs/04-package-management.md`
- `docs/05-kernel-and-modules.md`
- `docs/06-firewall-and-networking.md`
- `docs/07-system-auditing-and-lynis.md`
- `docs/08-filesystems-and-partitions.md`
- `docs/09-services-and-boot-hardening.md`
- `docs/10-ssh-and-authentication.md`
- `docs/11-kernel-tuning.md`
- `docs/12-mandatory-access-control.md`
- `docs/13-fail2ban.md`
- `THREAT_MODEL.md`
- `TESTED_ON.md`
- `QUICKSTART.md`
- `SECURITY.md`
- `scripts/README.md`
- `scripts/ufw_desktop_baseline.sh`
- `scripts/fail2ban_sshd_example.sh`
- `scripts/sysctl_endpoint_baseline.sh`
- `scripts/service_review.sh`

### Changed

- expanded UFW guidance into separate workstation
  and server examples
- rewrote SSH guidance into a safer Debian/Ubuntu
  OpenSSH hardening workflow
- rewrote kernel tuning into a persistent
  `sysctl.d`-based hardening model
- rewrote filesystem hardening into a real `fstab`
  and `findmnt` workflow
- rewrote service minimization into a
  systemd-based operational guide

### Notes

- repository scope is Debian/Ubuntu-first
- scripts are examples, not blind hardening wrappers
- users should verify all changes before trusting them
  in production