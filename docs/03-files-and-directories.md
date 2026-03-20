# 03 – Files and Directories

Hardening work is mostly file and directory work.

You inspect configuration files, create override files, move backups into place, and remove things you no longer need.

This section covers the core commands used throughout the repository.

## 1. Viewing file contents

Display a file:

```bash
cat examplefile
````

This is useful for short files, quick checks, and confirming generated output.

For longer files, use tools like `less`, but `cat` remains useful for direct inspection and scripting.

## 2. Creating files with redirection

Create a file by redirecting input into it:

```bash
cat > examplefile
```

Append more content instead of overwriting:

```bash
cat >> examplefile
```

Be careful:

* `>` overwrites
* `>>` appends

Confusing the two is a classic way to destroy a config.

## 3. Creating empty files

Create an empty file if it does not exist:

```bash
touch examplefile.txt
```

This is useful for placeholders, overrides, and simple file creation.

## 4. Creating directories

Create a directory:

```bash
mkdir exampledirectory
```

Then move into it:

```bash
cd exampledirectory
```

## 5. Copying files

Copy a file:

```bash
cp examplefile.txt examplefilenew.txt
```

This is especially useful before editing config files.

A common safe pattern is:

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

Backups before edits are not optional on important systems.

## 6. Moving or renaming files

Move a file or rename it:

```bash
mv oldfile newfile
```

This works for:

* renaming files
* moving files into new directories
* replacing temporary configs with final ones

## 7. Removing files

Remove a file:

```bash
rm newfile
```

Remove an empty directory:

```bash
rmdir exampledirectory
```

Remove a directory and all contents:

```bash
rm -r exampledirectory
```

Use recursive deletion carefully. On Linux, the shell will often let you destroy exactly what you asked it to destroy.

## 8. Practical habits

Before editing or deleting, get used to checking:

```bash
pwd
ls -la
```

Before changing a system config, get used to making a backup:

```bash
cp file file.bak
```

Before removing a directory recursively, be absolutely sure you are targeting the right path.

## Bottom line

Most Linux mistakes are not mysterious.

They are file and path mistakes made too quickly.
