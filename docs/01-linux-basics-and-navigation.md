# 01 – Linux Basics and Navigation

This section covers the minimum command-line literacy needed to work through the rest of the repository without guessing.

These commands are basic, but they matter because every later hardening or verification step depends on being comfortable moving around the system and reading what is there.

## 1. Working directory and identity

Check where you are:

```bash
pwd
````

Check which user you are operating as:

```bash
whoami
```

These two commands should become reflexes.

Before running a destructive command, know both:

* where you are
* who you are

## 2. Navigating the filesystem

Change directory:

```bash
cd /etc
```

Move up one level:

```bash
cd ..
```

Move up two levels:

```bash
cd ../..
```

Move up three levels:

```bash
cd ../../..
```

Jump to the filesystem root:

```bash
cd /
```

Use explicit paths when possible. The less ambiguity, the fewer mistakes.

## 3. Listing directory contents

List the current directory:

```bash
ls
```

List a specific directory:

```bash
ls /etc
```

Long listing format:

```bash
ls -l
```

This shows:

* permissions
* owner
* group
* size
* modification time
* filename

Show hidden files as well:

```bash
ls -la
```

This is important because configuration and state often live in dotfiles and dot-directories.

## 4. Using manual pages

Most serious commands have a manual page.

Read it like this:

```bash
man ls
man find
man sshd_config
```

This matters because Linux hardening done from memory alone is how people make avoidable mistakes.

## 5. Operational habit

Before changing anything important, get used to checking:

```bash
pwd
whoami
ls -la
```

That small habit prevents a surprising number of bad edits and accidental deletes.


