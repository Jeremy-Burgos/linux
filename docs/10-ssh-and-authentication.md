# 10 – SSH and Authentication Hardening

SSH is one of the most common and most valuable administrative entry points on a Linux system.

It is also one of the easiest places to make serious mistakes.

This file is written for Debian and Ubuntu systems using OpenSSH.

## 1. Know whether SSH should exist at all

Before hardening SSH, first decide whether the host should be accepting SSH connections at all.

Check whether anything is listening on port 22:

```bash
ss -tulpen | grep ':22'
````

Check whether the SSH service is enabled:

```bash
systemctl status ssh
systemctl is-enabled ssh
```

If the system does not need inbound SSH, the strongest hardening choice is usually not to expose it.

## 2. Understand the config layout on Debian and Ubuntu

The main server config file is typically:

```text
/etc/ssh/sshd_config
```

Debian and Ubuntu OpenSSH packages also support:

```text
/etc/ssh/sshd_config.d/*.conf
```

Use that include directory for hardening overrides instead of rewriting the base file unless you have a reason to do otherwise.

## 3. Back up the current config before touching it

Before editing SSH configuration:

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo mkdir -p /etc/ssh/sshd_config.d
```

If you already use `sshd_config.d`, back up any relevant override files too.

## 4. Inspect the current effective configuration

Do not trust comments or assumptions. Inspect what `sshd` will actually use.

Basic syntax and key sanity check:

```bash
sudo sshd -t
```

Effective configuration view:

```bash
sudo sshd -T | less
```

This is useful because distro defaults, include files, and package behavior can make the final config differ from what you expect by reading one file.

## 5. Recommended baseline settings

Create a hardening override file:

```bash
sudo nano /etc/ssh/sshd_config.d/99-hardening.conf
```

Example baseline:

```text
PermitRootLogin no
PermitEmptyPasswords no
IgnoreRhosts yes
HostbasedAuthentication no
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
X11Forwarding no
AllowAgentForwarding no
AllowTcpForwarding no
MaxAuthTries 3
LoginGraceTime 30
ClientAliveInterval 300
ClientAliveCountMax 2
```

## 6. What each baseline setting is doing

## PermitRootLogin no

Do not allow direct SSH logins as root.

Use a normal administrative account and escalate with `sudo`.

## PermitEmptyPasswords no

Never allow accounts with empty passwords to authenticate.

## IgnoreRhosts yes

Do not trust old rhosts-style host trust mechanisms.

## HostbasedAuthentication no

Disable host-based authentication unless you intentionally use and manage it.

## PubkeyAuthentication yes

Allow public-key authentication.

This should be the normal path for administrative SSH access.

## PasswordAuthentication no

Disable password-based SSH login.

Only do this after you have confirmed that working key-based access exists for at least one authorized account.

If you are not ready for key-only access, leave this enabled temporarily and plan the transition properly.

## KbdInteractiveAuthentication no

Disable keyboard-interactive authentication unless you specifically need it for MFA, PAM-backed flows, or centralized auth.

If your environment relies on it, do not turn it off casually.

## X11Forwarding no

Disable X11 forwarding unless you deliberately need it.

## AllowAgentForwarding no

Disable agent forwarding unless you intentionally need it.

Agent forwarding expands risk if you connect onward from the host.

## AllowTcpForwarding no

Disable SSH port forwarding unless you intentionally use it.

Forwarding is powerful and useful, but it also widens the abuse surface.

## MaxAuthTries 3

Reduce repeated guess attempts per connection.

## LoginGraceTime 30

Reduce how long unauthenticated clients can sit before authenticating.

## ClientAliveInterval 300

## ClientAliveCountMax 2

Drop dead or abandoned sessions more aggressively.

These are operational controls, not magical security features, but they tighten session handling.

## 7. Authentication strategy

For most exposed systems, the sane baseline is:

1. non-root admin account
2. public-key authentication
3. `sudo` for privilege escalation
4. password login disabled after key access is confirmed

Do not disable password authentication until you have:

1. generated and installed working SSH keys
2. confirmed a real login with those keys
3. kept one existing admin session open while testing

## 8. Validate before reloading

After saving changes:

```bash
sudo sshd -t
```

If that command returns no output and no error, syntax is acceptable.

Then inspect the effective values you care about:

```bash
sudo sshd -T | egrep 'permitrootlogin|permitemptypasswords|ignorerhosts|hostbasedauthentication|pubkeyauthentication|passwordauthentication|kbdinteractiveauthentication|x11forwarding|allowagentforwarding|allowtcpforwarding|maxauthtries|logingracetime|clientaliveinterval|clientalivecountmax'
```

Do not reload the service until the config validates.

## 9. Reload safely

If the config is valid:

```bash
sudo systemctl reload ssh
```

Then verify service state:

```bash
systemctl status ssh
```

If you are making changes remotely:

1. keep your current SSH session open
2. open a second fresh session and confirm login still works
3. only then close the original session

Do not trust a reload until you have tested a real new connection.

## 10. Rollback

If you break SSH and still have local or console access:

```bash
sudo rm -f /etc/ssh/sshd_config.d/99-hardening.conf
sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
sudo sshd -t
sudo systemctl restart ssh
```

If you are remote-only and you break SSH, your rollback options may be limited to:

1. cloud provider console
2. hypervisor console
3. rescue mode
4. out-of-band management

Plan before you cut the branch you are sitting on.

## 11. Optional stronger restrictions

If the host has a very narrow role, you can go further.

Examples:

1. bind SSH only to a specific management interface
2. restrict allowed users with `AllowUsers`
3. restrict allowed groups with `AllowGroups`
4. move SSH behind a VPN
5. combine with fail2ban
6. use hardware-backed or FIDO-backed SSH keys where appropriate

These are useful, but they should be applied intentionally, not as decoration.

## 12. Quick review checklist

Review these questions:

1. should SSH be exposed at all
2. is root login disabled
3. are empty passwords blocked
4. is key-based auth working
5. is password auth disabled where appropriate
6. are forwarding features disabled unless needed
7. was the config syntax-tested
8. was a real second login tested after reload

## Bottom line

SSH should be treated as a controlled administrative boundary, not a default convenience service.

A professional SSH posture is not just “set a few lines in `sshd_config`.” It is:

1. minimal exposure
2. strong authentication
3. safe validation
4. tested reloads
5. a real rollback path