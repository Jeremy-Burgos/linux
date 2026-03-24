# 06 – Firewall and Networking (UFW)

For Debian and Ubuntu systems, UFW is a practical way to enforce a simple, understandable host firewall policy.

This file covers two different roles:

1. workstation baseline
2. internet-facing server baseline

Those are not the same thing.

A workstation usually needs little or no inbound access.

A server usually needs a very small, explicitly justified set of inbound ports.

This document also uses `ss` as the verification layer, because firewall rules only matter if they match the actual network exposure of the host.

## 1. Why this matters

A firewall does not make a bad service safe.

It does help reduce accidental exposure and constrain what can talk to the host.

A professional workflow is:

1. identify the role of the machine
2. define the minimum required inbound access
3. apply UFW rules that match that role
4. verify both the firewall and the live listening sockets

Do not open ports because a guide mentions them. Open ports only because the host actually needs them.

## 2. Install UFW

On Debian and Ubuntu:

```bash
sudo apt-get update
sudo apt-get install ufw
````

Check status before making changes:

```bash
sudo ufw status verbose
```

## 3. Inspect what is listening before writing rules

Before applying firewall rules, inspect the host:

```bash
ss -tulpen
```

This tells you what is actually listening, including:

* TCP listeners
* UDP listeners
* bound addresses
* process associations

If you do not know why something is listening, do not just firewall around it. Investigate the service itself.

## 4. Workstation baseline

Use this profile for:

* laptops
* desktops
* developer machines
* personal Debian or Ubuntu systems
* workstations that do not intentionally accept inbound admin or application traffic

### 4.1 Baseline policy

For a normal workstation, the sane default is:

* deny incoming
* allow outgoing

Apply it:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

Verify:

```bash
sudo ufw status verbose
sudo ufw status numbered
```

Then inspect live listeners again:

```bash
ss -tulpen
```

A good workstation result is usually:

* UFW active
* incoming denied by default
* few or no unnecessary listeners
* no random server software exposed

### 4.2 Why this works for normal desktop use

Most workstation tasks are outbound:

* web browsing
* package updates
* email
* APIs
* VPN connections
* cloud synchronization

That means a default inbound deny policy usually fits daily use without opening ports manually.

If something breaks, the first question is not “how do I open more ports.” The first question is “why does this workstation need inbound access at all.”

## 5. Internet-facing server baseline

Use this profile for:

* VPS systems
* self-hosted services
* admin boxes that intentionally accept SSH
* web servers
* reverse proxies

A server is different because it exists to accept some inbound traffic.

The hardening goal is not “no ports.” The goal is “only the ports the role actually needs.”

### 5.1 Example: SSH and HTTPS only

If the host is intended to expose only SSH and HTTPS:

```bash
sudo apt-get update
sudo apt-get install ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22/tcp
sudo ufw allow 443/tcp

sudo ufw enable
```

Verify:

```bash
sudo ufw status verbose
sudo ufw status numbered
ss -tulpen
```

Review the result carefully:

* UFW should show only the rules you intended
* `ss -tulpen` should show only the services that are actually listening
* if a service is listening on a port you did not intend to expose, fix the service, not just the firewall rule

### 5.2 Example: internal-only admin service

If a service should only be reachable from a private subnet:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 443 proto tcp
```

Verify:

```bash
sudo ufw status numbered
```

Restrict by source whenever possible. Wide-open rules should be the exception, not the default.

## 6. Rule review and cleanup

List numbered rules:

```bash
sudo ufw status numbered
```

Delete a rule by number:

```bash
sudo ufw delete <rule-number>
```

Example:

```bash
sudo ufw delete 3
```

You can also insert rules at a specific position when order matters:

```bash
sudo ufw insert 1 deny from 203.0.113.10
```

The firewall should reflect the current role of the machine, not years of old experiments.

## 7. UFW application profiles

UFW can also use application profiles from:

```text
/etc/ufw/applications.d/
```

List available application profiles:

```bash
sudo ufw app list
```

Show details for one profile:

```bash
sudo ufw app info '<profile-name>'
```

This can be useful, but do not trust application profiles blindly. Review what port and protocol they actually open.

## 8. Remote management caution

If you are enabling UFW on a remote host, plan carefully.

Enabling the firewall can disrupt existing connections if you have not already allowed the traffic you need.

For example, if you administer a remote host over SSH and intend to keep doing that, the SSH allow rule must exist before enabling UFW.

Do not harden remotely without:

1. a second session open
2. console or out-of-band recovery if possible
3. a clear rollback path

## 9. Firewall verification workflow

After any meaningful firewall change, review all three of these:

```bash
sudo ufw status verbose
sudo ufw status numbered
ss -tulpen
```

That gives you:

1. firewall active state and defaults
2. exact ordered rules
3. actual listening sockets on the host

This is the operational loop that matters.

## 10. What not to do

Do not:

* open SSH on every system just because it is common
* apply server firewall examples to normal workstations
* assume UFW makes a vulnerable exposed service safe
* keep stale rules after the related service has been removed
* trust old rules without checking current listening sockets

## 11. Quick review checklist

Before calling the firewall setup complete, confirm:

1. the role of the machine is clear
2. UFW is installed and active
3. default policy matches the role
4. inbound rules are minimal and justified
5. numbered rules were reviewed
6. live listening sockets were reviewed with `ss -tulpen`
7. remote access was tested safely if the host is remote

## Bottom line

A professional Linux firewall posture is not just “turn on UFW.”

It is:

1. role-aware
2. minimal
3. verified against live listeners
4. maintained as services change
