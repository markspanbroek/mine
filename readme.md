Mine̼, a password and key manager
================================

Warning: this is highly experimental. Do not use for real passwords and keys!

Installation
------------

Currently only macOS and Qubes OS are supported.

To install, download these sources and compile them with a recent version of [Nim][1] using the command `nimble build`.

On macOS, you can now use the `mine` binary using the instructions below.

On Qubes OS, you should only run the `mine` binary in the `vault` VM. Make
sure that you move the `mine` binary to the `vault` VM before use.

[1]: https://nim-lang.org

Command Line Usage
------------------

Start by creating a main secret:

```bash
mine create
```

Derive a password for user 'octo' at 'github.com':

```bash
mine password octo github.com
```

Derive a PIN for bank card 'visa':

```bash
mine pin visa
```

Derive a mnemonic for a wallet called 'ethereum':

```bash
mine mnemonic ethereum
```

Derive a password for a wifi access point called 'my wifi':

```bash
mine wifi 'my wifi'
```

Delete the main secret from your computer:

```bash
mine delete
```

Restore a main secret from the backup phrases:

```bash
mine restore
```
