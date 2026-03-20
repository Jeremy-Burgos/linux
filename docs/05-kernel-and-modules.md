# 05 – Kernel and Modules

The Linux kernel is the foundation of the system.

Kernel modules extend it at runtime, which means they are powerful and sensitive by default.

This section focuses on visibility, not reckless module surgery.

## 1. Check the running kernel

Show kernel and system information:

```bash
uname -a
````

Show version details from `/proc`:

```bash
cat /proc/version
```

These commands help confirm exactly what the system is running before making assumptions about behavior, compatibility, or available features.

## 2. List loaded kernel modules

Show currently loaded modules:

```bash
lsmod
```

This is your first-pass inventory of what has been added to the kernel.

You do not need to recognize every module by memory, but you should treat the list as something worth understanding on systems you care about.

## 3. Inspect a specific module

Get information about a module:

```bash
modinfo <module-name>
```

Example:

```bash
modinfo nf_conntrack
```

This helps answer:

* what the module is
* who maintains it
* what parameters it exposes
* where it lives on disk

## 4. Load a module

Load a module:

```bash
sudo modprobe <module-name>
```

Example:

```bash
sudo modprobe loop
```

This should only be done intentionally and with a clear reason.

## 5. Remove a module

Remove a module:

```bash
sudo modprobe -r <module-name>
```

Example:

```bash
sudo modprobe -r loop
```

Do not unload modules casually on a system you rely on.

Questions to ask first:

* is something currently using this module
* is it required by another module
* is it required by hardware or the current workload

## 6. Verify module behavior

Check kernel messages for module-related output:

```bash
dmesg | grep <module-name>
```

Example:

```bash
dmesg | grep loop
```

This can help confirm whether a module loaded, failed, or generated warnings.

## 7. Operational discipline

For most users, module work should start with:

* `uname -a`
* `lsmod`
* `modinfo`
* `dmesg`

Do not jump straight to `modprobe -r` unless you understand the dependency chain and role of the host.

## Bottom line

Kernel modules are not just “packages that happen to be loaded.”

They are code running inside the kernel.

Treat them with more caution than normal userland software.
