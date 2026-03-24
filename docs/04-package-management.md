# 04 – Package Management (APT)

Patch discipline and package hygiene are part of hardening.

A system with clean firewall rules and weak package hygiene is still a weak system.

This section covers the APT commands used most often on Debian and Ubuntu systems.

## 1. Installing packages

Install a package:

```bash
sudo apt-get install <packagename>
````

Example:

```bash
sudo apt-get install ufw
```

On a hardening-focused system, install only what you need and understand.

## 2. Removing packages

Remove a package but leave some configuration behind:

```bash
sudo apt-get remove <packagename>
```

Example:

```bash
sudo apt-get remove apache2
```

This is useful when you want to stop using software but may still want to inspect or preserve its configs briefly.

## 3. Purging packages

Remove a package and its configuration files:

```bash
sudo apt-get purge <packagename>
```

Example:

```bash
sudo apt-get purge apache2
```

This is often the cleaner choice when removing server software that no longer belongs on the host.

## 4. Autoremove

Remove packages that were installed as dependencies but are no longer needed:

```bash
sudo apt autoremove
```

This helps clean up stale components after package removal.

## 5. Updating package metadata

Refresh the package index:

```bash
sudo apt-get update
```

This should happen before installing or upgrading packages so the system has current package metadata.

## 6. Upgrading packages

Upgrade installed packages to newer available versions:

```bash
sudo apt-get upgrade
```

This is baseline patch hygiene.

## 7. Practical workflow

A simple safe pattern is:

```bash
sudo apt-get update
sudo apt-get upgrade
```

Then, when needed:

```bash
sudo apt-get install <packagename>
sudo apt autoremove
```

Do not treat package management as a one-time setup event. Hardening depends on maintenance.

## 8. Package hygiene questions

Ask these regularly:

* why is this package installed
* does this package expose a service
* is this package still needed
* did this package bring in dependencies I forgot about
* should this package be removed or purged

## Bottom line

Patch lag and package sprawl are both attack-surface problems.

A hardened Debian or Ubuntu system should be current and intentional about what is installed.
