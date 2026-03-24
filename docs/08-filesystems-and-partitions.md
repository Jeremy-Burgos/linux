# 08 – Filesystems and Partitions

Filesystem hardening is one of the cleanest ways to reduce post-compromise abuse.

This is not about making Linux “more secure” in the abstract. It is about making risky directories and removable media behave more deliberately.

On Debian and Ubuntu systems, the right questions are:

1. what is mounted
2. how it is mounted
3. whether the mount options fit the role of the machine
4. whether those settings persist cleanly in `/etc/fstab`

## 1. Why this matters

Mount options can reduce abuse paths by limiting what can happen on a given filesystem.

The most important options in normal hardening work are:

- `nodev`
- `nosuid`
- `noexec`

At a high level:

- `nodev` prevents device files on that filesystem from being interpreted as devices
- `nosuid` prevents setuid and setgid bits on that filesystem from taking effect
- `noexec` prevents direct execution of binaries from that filesystem

These are not magic. They are still useful friction.

## 2. Start with the role of the machine

Before changing mount options, decide what the machine is.

### Workstation

Examples:

- laptop
- desktop
- developer machine
- research workstation

Normal expectation:

- removable media should be treated cautiously
- `/tmp` should usually be tighter than the root filesystem
- user-writable paths should not be granted more freedom than they need

### Administrative workstation

Examples:

- jump box
- admin endpoint
- security tooling host

Normal expectation:

- even tighter review of writable and removable locations
- explicit mount decisions instead of defaults where practical

### Server

Examples:

- VPS
- app host
- database server
- self-hosted service

Normal expectation:

- role-specific partitioning matters more
- `/var`, `/tmp`, and sometimes `/home` deserve explicit review
- do not apply workstation assumptions blindly to service paths that genuinely need execution

## 3. Inspect the current filesystem layout

Start by reviewing `fstab`:

```bash
cat /etc/fstab
````

Then inspect what is actually mounted now:

```bash
findmnt
```

For a more compact view:

```bash
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS
```

This lets you compare:

* the intended persistent config in `/etc/fstab`
* the actual live mount state

Do not assume they are identical without checking.

## 4. Use stable identifiers in fstab

Where possible, prefer:

* `UUID=`
* `LABEL=`
* `PARTUUID=`
* `PARTLABEL=`

over raw `/dev/sdX` device names.

Why:

* device names can change when disks are added, removed, or enumerated differently
* UUID and label based mounts are more stable and more professional

You can inspect identifiers with:

```bash
lsblk -f
blkid
```

## 5. Common paths worth reviewing

Not every system has separate partitions for these, but when they do exist, these are the highest-value review points:

* `/tmp`
* `/var`
* `/home`
* `/opt`
* `/media`
* `/mnt`

The CIS-style logic behind this is simple:

* writable locations should not get unnecessary privilege features
* removable media should be especially constrained
* directories that do not need execution should not automatically allow it

## 6. What the main mount options mean

## nodev

Use `nodev` where users or untrusted content should not be able to create device nodes with effect.

Typical candidates:

* `/tmp`
* `/home`
* `/var` in some designs
* removable media mounts

## nosuid

Use `nosuid` where you do not want setuid/setgid bits on that filesystem to grant privilege.

Typical candidates:

* `/tmp`
* `/home`
* `/var` in many cases
* removable media mounts

## noexec

Use `noexec` where the filesystem does not need direct binary execution.

Typical candidates:

* `/tmp`
* some removable media mounts
* some dedicated data-only mounts

Use this with judgment. `noexec` can break legitimate workflows, especially on developer systems, custom tooling hosts, or software that stages runnable content in temporary paths.

## 7. Sensible baseline guidance by path

## /tmp

High-value candidate for:

```text
nodev,nosuid,noexec
```

Why:

* highly writable
* commonly abused
* usually not meant to host trusted executable content

Caution:

* some installers, build systems, and scripts may behave badly if `/tmp` is `noexec`

## /var

Possible candidate for:

```text
nodev,nosuid
```

Sometimes also `noexec`, but only with care.

Why:

* contains variable application and service data
* may contain logs, caches, spools, and package/application state

Caution:

* many services live under `/var` in ways that can break if `noexec` is applied carelessly

## /home

Possible candidate for:

```text
nodev,nosuid
```

Sometimes `noexec`, but only with strong role awareness.

Why:

* user-controlled content lives here
* reduces abuse of setuid and device files in user space

Caution:

* `noexec` on `/home` can break developer workflows, scripts, AppImage-style tooling, local binaries, and research environments

## /opt

Possible candidate for:

```text
nodev
```

Sometimes `nosuid`, depending on how software is managed.

Caution:

* many third-party applications install here and may require normal execution semantics
* do not apply `noexec` blindly to `/opt`

## /media and removable storage

Strong candidate for:

```text
nodev,nosuid,noexec
```

Why:

* removable media is an obvious untrusted-content boundary
* these controls reduce the chance of casual abuse from inserted media

## 8. Example fstab entries

These are examples, not universal defaults.

### Example: separate /tmp with tight options

```text
UUID=11111111-2222-3333-4444-555555555555  /tmp   ext4  defaults,nodev,nosuid,noexec  0  2
```

### Example: separate /home with moderate restrictions

```text
UUID=66666666-7777-8888-9999-aaaaaaaaaaaa  /home  ext4  defaults,nodev,nosuid          0  2
```

### Example: removable media mount point policy

```text
UUID=bbbbbbbb-cccc-dddd-eeee-ffffffffffff  /media/data  ext4  defaults,nodev,nosuid,noexec,nofail  0  2
```

Use `nofail` for devices that may not always be present and should not block boot if absent.

## 9. Edit fstab carefully

Before editing:

```bash
sudo cp /etc/fstab /etc/fstab.bak
sudo nano /etc/fstab
```

Remember:

* each filesystem entry is on its own line
* fields are separated by spaces or tabs
* comments begin with `#`
* line order matters for tools such as `mount` and `fsck`

Do not rush this file. A bad `fstab` can break boot or leave expected filesystems unavailable.

## 10. Test before rebooting

After editing `fstab`, test it before rebooting:

```bash
sudo mount -a
```

If that command returns cleanly, your syntax and mountability are probably sane.

Then verify live state:

```bash
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS
```

Or inspect a specific mount:

```bash
findmnt --target /tmp
findmnt --target /home
findmnt --target /var
```

Do not wait until reboot to discover a broken entry.

## 11. Remount for immediate testing

If you want to test a new option on an already-mounted filesystem, you can remount it.

Example:

```bash
sudo mount -o remount,nodev,nosuid,noexec /tmp
```

Then verify:

```bash
findmnt --target /tmp -o TARGET,OPTIONS
```

This is useful for short testing, but the persistent source of truth should still be `/etc/fstab`.

## 12. Verify the final state

Use `findmnt` as the primary verification tool.

Examples:

```bash
findmnt -o TARGET,OPTIONS
findmnt --target /tmp -o TARGET,SOURCE,FSTYPE,OPTIONS
findmnt --target /home -o TARGET,SOURCE,FSTYPE,OPTIONS
```

You can also inspect from the kernel view:

```bash
mount | grep ' on /tmp '
mount | grep ' on /home '
mount | grep ' on /var '
```

What matters is not what you intended to write. What matters is what the system actually mounted.

## 13. When not to apply a hardening option blindly

Do not apply `noexec`, `nosuid`, or `nodev` blindly just because a benchmark says so.

Examples of where careless use causes problems:

* developer workstations
* build systems
* scientific computing environments
* custom tooling installed under `/opt`
* service hosts that expect executable content in paths under `/var`
* container or virtualization workloads with unusual mount behavior

Hardening is role-aware, or it is just breakage.

## 14. Rollback

If a mount-option change breaks the system or a workflow:

1. restore the previous `fstab` if needed
2. remount the affected filesystem with the prior options
3. verify the live state again

Example rollback:

```bash
sudo cp /etc/fstab.bak /etc/fstab
sudo mount -a
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS
```

If the host is remote and the broken mount affects boot or service startup, recovery may require console access.

## 15. Quick review checklist

Before calling filesystem hardening complete, confirm:

1. the role of the machine is clear
2. `/etc/fstab` has been reviewed
3. live mounts have been reviewed with `findmnt`
4. stable identifiers such as `UUID=` are used where practical
5. mount options are appropriate for the filesystem’s role
6. `mount -a` was tested before reboot
7. live options were verified after changes
8. rollback is understood

## Bottom line

Filesystem hardening is not about slapping `noexec` everywhere.

A professional workflow is:

1. understand the role of the machine
2. inspect `fstab`
3. inspect live mounts
4. apply only the restrictions the path can actually tolerate
5. test before reboot
6. verify what the kernel actually mounted