# 11 – Kernel Tuning with sysctl.d

Kernel network hardening is not just a matter of checking live values under `/proc/sys/`.

A professional Linux hardening workflow needs to answer three questions:

1. what is the current live value
2. what value should persist across reboot
3. how do you verify that the persistent configuration actually applied

On Debian and Ubuntu systems using systemd, the correct persistence model is `sysctl.d`, not a vague collection of one-off `sysctl -w` commands.

## 1. Why this matters

Kernel networking defaults can expose unnecessary behavior on endpoints and admin systems.

Common examples include:

- accepting source-routed traffic
- accepting ICMP redirects
- forwarding packets when the host is not meant to route traffic
- behaving too loosely on multihomed systems

These are not all equally dangerous on every machine, but they are exactly the kind of settings that should be made explicit.

## 2. The right persistence model on Debian and Ubuntu

For systemd-based Debian and Ubuntu systems, persistent sysctl settings should be managed with files under:

```text
/etc/sysctl.d/
````

Do not treat ad hoc `sysctl -w ...` commands as a hardening strategy. Those only affect the running system unless you also persist the settings.

A clean local-admin pattern is to use a dedicated file such as:

```text
/etc/sysctl.d/99-hardening.conf
```

That makes your changes:

* easy to audit
* easy to diff
* easy to override or remove
* clearly separate from vendor defaults

## 3. Inspect current live values

Before changing anything, inspect the current state.

```bash
sysctl net.ipv4.conf.all.accept_source_route
sysctl net.ipv4.conf.default.accept_source_route
sysctl net.ipv4.icmp_echo_ignore_broadcasts
sysctl net.ipv4.conf.all.accept_redirects
sysctl net.ipv4.conf.default.accept_redirects
sysctl net.ipv4.conf.all.secure_redirects
sysctl net.ipv4.conf.default.secure_redirects
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
sysctl net.ipv4.conf.all.rp_filter
sysctl net.ipv4.conf.default.rp_filter
```

You can also inspect directly via `/proc/sys`, but `sysctl` output is easier to read consistently.

## 4. Recommended baseline for Debian and Ubuntu endpoints

For normal workstations, laptops, and admin systems that are not intended to route traffic, this is a sensible baseline:

```text
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

net.ipv4.icmp_echo_ignore_broadcasts = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0

net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
```

What this does at a high level:

* disables source-routed traffic
* ignores ICMP broadcast echo requests
* disables redirect acceptance
* disables packet forwarding for non-router hosts
* enables basic reverse-path filtering for IPv4

This is a reasonable host baseline, not a universal router or appliance baseline.

## 5. Create a persistent hardening file

Create a local hardening file:

```bash
sudo nano /etc/sysctl.d/99-hardening.conf
```

Suggested contents:

```text
# Endpoint-focused kernel network hardening
# Debian/Ubuntu local admin override

net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

net.ipv4.icmp_echo_ignore_broadcasts = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0

net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
```

Keep the file narrow and intentional. Do not dump fifty unrelated sysctl values into it because a random benchmark did.

## 6. Apply the persistent configuration

After saving the file, reload sysctl settings through the systemd path:

```bash
sudo systemctl restart systemd-sysctl
```

If you want to test specific values temporarily before committing them to disk, you can still do:

```bash
sudo sysctl -w net.ipv4.conf.all.accept_source_route=0
```

But that is for testing, not for long-term configuration management.

## 7. Verify the settings actually applied

After reloading, verify live values again:

```bash
sysctl net.ipv4.conf.all.accept_source_route
sysctl net.ipv4.conf.default.accept_source_route
sysctl net.ipv4.icmp_echo_ignore_broadcasts
sysctl net.ipv4.conf.all.accept_redirects
sysctl net.ipv4.conf.default.accept_redirects
sysctl net.ipv4.conf.all.secure_redirects
sysctl net.ipv4.conf.default.secure_redirects
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
sysctl net.ipv4.conf.all.rp_filter
sysctl net.ipv4.conf.default.rp_filter
```

You can also inspect the effective local file:

```bash
sudo cat /etc/sysctl.d/99-hardening.conf
```

And review the combined configuration if needed by reading the relevant `sysctl.d` files under:

```text
/etc/sysctl.d/
/run/sysctl.d/
/usr/lib/sysctl.d/
```

## 8. Important caution about ip_forward

`net.ipv4.ip_forward` is not just another random toggle.

Changing it is special because the kernel resets related configuration defaults depending on whether the host is acting like a router or a normal endpoint.

That means:

* set it intentionally
* keep it persistent in your chosen config file
* verify the post-change state instead of assuming all related values stayed the same

For most desktops, laptops, and admin hosts, the correct setting is:

```text
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
```

If the machine is intentionally acting as a router, gateway, VPN concentrator, or container host with forwarding requirements, do not apply an endpoint profile blindly.

## 9. When not to use this baseline unchanged

Do not apply this exact baseline unchanged to:

* routers
* firewalls
* VPN gateways
* Kubernetes nodes without understanding networking requirements
* hosts intentionally performing packet forwarding or specialized routing
* systems with multihomed networking that require different `rp_filter` behavior

Hardening without role awareness is how you break working systems.

## 10. Rollback

If you need to undo the hardening file:

```bash
sudo rm -f /etc/sysctl.d/99-hardening.conf
sudo systemctl restart systemd-sysctl
```

Then verify the live values again.

If you want to disable only one setting, edit the file rather than deleting everything. Keep the rollback as controlled as the original change.

## 11. Quick review checklist

Before calling kernel tuning complete, confirm:

1. the system is actually Debian or Ubuntu-like
2. the host is not supposed to route traffic
3. the values were persisted in `/etc/sysctl.d/99-hardening.conf`
4. `systemd-sysctl` was reloaded
5. the live values match the expected values
6. you understand the role of the machine before forcing endpoint-only settings onto it

## Bottom line

A live `/proc/sys` check is not a hardening strategy.

A real kernel-network hardening workflow for Debian and Ubuntu is:

1. inspect current values
2. persist intentional values in `sysctl.d`
3. reload cleanly
4. verify live state
5. avoid applying endpoint assumptions to systems that are meant to route traffic
