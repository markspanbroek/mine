import options
import ../storage
import ../backup
import ../secrets
import ../console
import ./mnemonic

proc checkNoMainSecret =
  if retrieveSecret("main").isSome:
    stderr.writeLine:
      "Refusing to restore from backup, because main secret already exists."
    quit(QuitFailure)

proc readBackupPhrase: Share =
  try:
    let mnemonic = readSecret()
    defer: wipe(mnemonic)
    result = mnemonicToShare(mnemonic)
    displayBlankedMnemonic()
  except:
    stderr.writeLine "Invalid backup phrase"
    quit(QuitFailure)

proc restore* =
  checkNoMainSecret()
  echo:
    "Restoring main secret from backup. You'll need to type in 2 of the 3 " &
    "backup phrases.\n"

  echo "Please enter the first backup phrase:"
  let share1 = readBackupPhrase()
  defer: wipe(share1)

  echo "Please enter the second backup phrase:"
  let share2 = readBackupPhrase()
  defer: wipe(share2)

  let root = restoreRootKey([share1, share2])
  defer: wipe(root)

  let main = root.deriveSecret("main")
  defer: wipe(main)

  storeSecret("main", main)

  echo "Main secret restored."
