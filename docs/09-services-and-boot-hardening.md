# 09 – Services and Boot Hardening

Hardening a Linux system is not only about adding controls.

It is also about removing unnecessary exposure.

The cleanest way to reduce attack surface on Debian and Ubuntu systems is to answer three questions:

1. what is enabled at boot
2. what is actually running right now
3. what is listening on the network right now

This document focuses on service minimization for systemd-based Debian and Ubuntu systems.

## 1. Why this matters

Every enabled service is:

- more code
- more configuration
- more logs
- more maintenance
- more opportunity for mistakes
- another possible entry point if it is network-facing

A host with fewer active services is easier to understand, easier to audit, and usually safer.

## 2. Start with the role of the machine

Before disabling anything, decide what the system is.

Typical roles:

### Workstation

Examples:

- laptop
- desktop
- developer machine
- research workstation

Normal expectation:

- very few inbound services
- no unnecessary daemons
- no accidental web server, database, or file-sharing service left running

### Administrative workstation

Examples:

- jump box used locally
- system used to manage remote infrastructure
- security research machine

Normal expectation:

- still minimal inbound exposure
- more tooling installed
- tighter review of helper services and background daemons

### Server

Examples:

- VPS
- internal application server
- database host
- reverse proxy
- self-hosted service

Normal expectation:

- only the services required for the host’s role should be enabled
- exposed ports must be justified deliberately
- hardening must avoid breaking the service the machine actually exists to run

Do not apply workstation assumptions blindly to a server, and do not apply server clutter to a workstation.

## 3. Inspect enabled services

List enabled unit files:

```bash
systemctl list-unit-files --state=enabled
````

This shows what is configured to start automatically.

For a narrower view of enabled service units:

```bash
systemctl list-unit-files --type=service --state=enabled
```

This is your starting inventory, not your final verdict.

A service being enabled does not automatically mean it is harmful. It does mean it deserves explanation.

## 4. Inspect what is running right now

List running services:

```bash
systemctl list-units --type=service --state=running
```

This is different from enabled-at-boot state.

A service may be:

* enabled but not currently running
* running but started indirectly
* socket-activated
* transient

That is why you need both views.

## 5. Inspect what is listening on the network

Use `ss` to inspect listening sockets:

```bash
ss -tulpen
```

This is one of the most important commands in the entire repo.

It tells you what is actually exposed right now, including:

* TCP listeners
* UDP listeners
* process association
* port bindings

If you do not recognize a listening service, investigate it before doing anything else.

For example, on a normal workstation, unexpected listeners on ports for web servers, databases, file sharing, or remote admin should be treated as suspicious until explained.

## 6. Correlate services with listening ports

Do not disable services based on guesses.

Correlate:

```bash
systemctl list-unit-files --type=service --state=enabled
systemctl list-units --type=service --state=running
ss -tulpen
```

This gives you three different views:

1. what starts automatically
2. what is active now
3. what is actually listening now

Professional service minimization is about correlation, not random package removal.

## 7. Common examples to review

These are examples of services that often deserve explicit review if they exist on a machine that does not need them:

* Apache
* Nginx
* MySQL
* MariaDB
* PostgreSQL
* Samba
* NFS-related services
* RPC-related services
* FTP services
* old remote admin tools
* Webmin
* Squid
* Avahi, depending on role and environment
* container tooling you installed temporarily and forgot about

Presence alone does not make them wrong. Lack of a reason does.

## 8. Disable and stop a service safely

If you determine a service is not needed, the clean pattern is:

```bash
sudo systemctl disable --now <service-name>
```

Example:

```bash
sudo systemctl disable --now apache2
```

This does two things:

1. disables startup at boot
2. stops the service immediately

That is better than stopping it only for the current session and forgetting that it will come back on reboot.

## 9. Verify the service is actually gone

After disabling a service, verify in three places.

Check whether it is still enabled:

```bash
systemctl is-enabled <service-name>
```

Check whether it is still active:

```bash
systemctl status <service-name>
```

Check whether the network listener is gone:

```bash
ss -tulpen
```

If a port is still listening after the main service was disabled, investigate whether:

* another service owns the socket
* the service is socket-activated
* a helper process is still running
* you disabled the wrong unit

## 10. Watch for socket activation

Some services are started on demand by socket units.

That means disabling only the service unit may not be enough.

Check for matching socket units:

```bash
systemctl list-unit-files --type=socket
systemctl list-units --type=socket
```

If a service keeps returning unexpectedly, look for a related socket unit and inspect it before assuming the service ignored your change.

## 11. Workstation baseline logic

For a normal Debian or Ubuntu workstation, the goal is usually:

* deny unnecessary inbound exposure
* keep only local-user-facing services
* remove test software and old daemons
* avoid running server software unless the machine is intentionally acting like a server

Normal workstation questions:

1. Why is anything listening at all?
2. Does this service need to start at boot?
3. Is this tied to a package I forgot I installed?
4. Is this convenience, or is it actually necessary?

A hardened workstation should feel explainable.

## 12. Server baseline logic

For an internet-facing or role-specific server, the goal is different.

You are not trying to remove all services. You are trying to ensure that only the intended services exist.

Normal server questions:

1. Is each listening port part of the server’s actual role?
2. Is each enabled service still required?
3. Are there old packages, admin panels, or databases still running from setup?
4. Is anything exposed that should only be local?
5. Are support services restricted as tightly as possible?

A hardened server should look intentionally minimal, not empty.

## 13. Legacy inetd and old service assumptions

If the host still has legacy `inetd`-style configuration or very old service patterns, review them directly.

For older-style setups:

```bash
cat /etc/inetd.conf
```

On modern Debian and Ubuntu systems, systemd is the main control plane, so prioritize `systemctl` and `ss` over older service-management habits.

## 14. Logging and review after changes

After disabling or changing services, review the journal:

```bash
journalctl -xeu <service-name>
```

This helps answer:

* did the service stop cleanly
* did another unit try to restart it
* is there a dependency issue
* did you break something that expected it to exist

Service minimization should reduce noise, not create blind spots.

## 15. Rollback

If you disabled something you actually need, reverse it cleanly:

```bash
sudo systemctl enable --now <service-name>
```

Example:

```bash
sudo systemctl enable --now apache2
```

Then verify with:

```bash
systemctl status <service-name>
ss -tulpen
```

Rollback should be controlled and explicit, not improvised.

## 16. Quick review checklist

Before calling service hardening complete, confirm:

1. the role of the machine is clear
2. enabled services have been reviewed
3. running services have been reviewed
4. listening ports have been reviewed
5. unnecessary services have been disabled with `disable --now`
6. listeners were verified after changes
7. socket-activated units were checked where relevant
8. rollback is understood for anything important

## Bottom line

Service hardening is one of the highest-value things you can do on Linux.

A professional workflow is:

1. identify the role of the machine
2. inventory enabled services
3. inventory running services
4. inventory listening sockets
5. disable what is not needed
6. verify the service and its listener are actually gone
7. repeat until the system looks intentional