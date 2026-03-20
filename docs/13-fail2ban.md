# 13 – Fail2ban

Fail2ban is useful when a host intentionally exposes services that attackers can hammer with repeated authentication attempts or noisy probing.

It is not a magic firewall, and it is not equally useful on every Linux system.

A workstation with no inbound services gains little from it.

A server with exposed SSH may gain a lot from it.

## 1. What Fail2ban does

Fail2ban watches logs for patterns such as repeated authentication failures and responds by applying temporary bans.

Its value is practical:

- it raises the cost of brute-force attempts
- it reduces repeated noise from abusive clients
- it gives you a simple control loop for exposed services

It does not replace:

- good SSH configuration
- service minimization
- strong authentication
- sane firewall policy

## 2. Install Fail2ban

Install the package:

```bash
sudo apt-get update
sudo apt-get install fail2ban
````

Check service status:

```bash
sudo systemctl status fail2ban
```

## 3. Configuration model

The packaged default configuration lives in:

```text
/etc/fail2ban/jail.conf
```

Do not edit that file directly.

Use local overrides instead.

Create:

```bash
sudo nano /etc/fail2ban/jail.local
```

This keeps your changes clean and easier to maintain.

## 4. Minimal SSH example

For a host that intentionally exposes SSH, a basic jail might look like this:

```ini
[DEFAULT]
banaction = ufw
bantime   = 1h
findtime  = 10m
maxretry  = 5

[sshd]
enabled = true
```

This says:

* use UFW for bans
* ban for one hour
* count failures over ten minutes
* ban after five failures
* apply the jail to SSH

This is a practical starting point, not a universal setting.

## 5. Restart and verify

After creating or changing `jail.local`:

```bash
sudo systemctl restart fail2ban
```

Check global status:

```bash
sudo fail2ban-client status
```

Check the SSH jail specifically:

```bash
sudo fail2ban-client status sshd
```

If you are using UFW integration, also review:

```bash
sudo ufw status numbered
```

## 6. When to use it

Fail2ban makes the most sense on hosts that:

* intentionally expose SSH
* expose login-backed web services
* receive real inbound abuse and probing
* are small enough that a lightweight local control is practical

## 7. When it adds little value

Fail2ban adds much less value on:

* local-only workstations
* systems with no inbound exposure
* hosts where the service itself should have been disabled instead

Do not install it just to say you have it.

## 8. Practical workflow

On a server that exposes SSH:

1. verify the host actually needs SSH exposed
2. harden SSH configuration first
3. apply minimal UFW rules
4. add a Fail2ban SSH jail
5. verify jail status
6. monitor whether it is doing useful work

That is the right order.

## Bottom line

Fail2ban is worth using when a host has real inbound exposure.

It is not a substitute for reducing attack surface in the first place.