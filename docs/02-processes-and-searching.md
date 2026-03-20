# 02 – Processes, Searching, and Filtering

A hardened system is not just one with fewer services.

It is one where you can quickly answer:

- what files exist
- what processes are running
- which of those processes matter
- whether the thing you are looking at is expected

This section covers simple but high-value visibility commands.

## 1. Finding files with `find`

Search from the root of the filesystem for a regular file by name:

```bash
find / -type f -name <query>
````

Example:

```bash
find / -type f -name sshd_config
```

This is slow, but direct.

Use `find` when you care about correctness more than convenience.

## 2. Wildcards

Wildcards help match patterns in filenames and arguments.

Single character:

```text
?
```

Character class:

```text
[]
```

Any length:

```text
*
```

Examples:

```bash
ls *.conf
ls ssh?.service
ls /etc/ssh/sshd_config.d/*.conf
```

Wildcards are useful. They are also dangerous when used with deletion or move commands. Expand them mentally before you trust them.

## 3. Process inspection with `ps`

Show basic process information:

```bash
ps
```

Show a fuller process view:

```bash
ps aux
```

This is a standard baseline view of what is currently running.

## 4. Filtering process output with `grep`

Search process output for a keyword:

```bash
ps aux | grep python3
```

This is useful for quick filtering, but remember:

* `grep` can match itself
* a matching name is not the same as a trustworthy process
* you still need to inspect PID, user, parent process, and path where relevant

## 5. Piping output

The pipe operator sends the output of one command to another:

```text
|
```

Example:

```bash
ps aux | grep ssh
```

This is foundational to Linux inspection work.

## 6. Practical workflow

When investigating a service, process, or configuration file, a simple pattern is:

1. find the file
2. inspect the process list
3. filter output for what matters
4. correlate the result with what the host is supposed to do

Examples:

```bash
find / -type f -name sshd_config
ps aux | grep ssh
locate fail2ban
```

## Bottom line

Linux hardening depends on visibility.

You cannot minimize what you cannot find, and you cannot trust what you have not inspected.