Mine̼, a password and key manager
================================

Warning: this is highly experimental. Do not use for real passwords and keys!

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

Derive a mnemonic for a wallet called 'ethereum':

```bash
mine mnemonic ethereum
```

Delete the main secret from your computer:

```bash
mine delete
```

Restore a main secret from the backup phrases:

```bash
mine restore
```
