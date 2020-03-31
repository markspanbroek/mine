import strformat
import sequtils
import options
import terminal
import ../root
import ../backup
import ../storage
import ../displaying
import ../secrets
import ./executable

proc displayErrorMainSecretAlreadyExists =
  stderr.writeLine:
    "Unable to create main secret because it already exists. If you really " &
    "want to create a new main secret you'll need to invoke " &
    fmt"'{getExecutableName()} delete' first."

proc checkNoMainSecretYet =
  if retrieveSecret("main").isSome:
    displayErrorMainSecretAlreadyExists()
    quit(QuitFailure)

proc displayBackupExplanation =
  echo:
    "Write down the following 3 backup phrases. You'll need at least 2 of " &
    "them to restore your passwords and keys. This is the ONLY way to " &
    "recover from data loss! So keep the backup phrases in separate, safe " &
    "places.\n"

proc displayBlankedMnemonic =
  echo:
    "***** ***** ***** ***** ***** ***** ***** ***** ***** ***** " &
    "***** ***** ***** ***** ***** ***** ***** ***** ***** ***** " &
    "***** ***** ***** ***** *****"

proc displayBackupPhrase(index: int, mnemonic: string) {.inline.} =
  echo fmt"Write down backup phrase #{index+1}, and press a key to continue:"
  let clear = display(mnemonic)
  discard getCh()
  clear()
  displayBlankedMnemonic()

proc create* =
  checkNoMainSecretYet()
  let root = createRootKey()
  let main = root.deriveSecret("main.0")
  let shares = root.shares(2, 3)
  wipe(root)
  let mnemonics = shares.mapIt(it.toMnemonic)
  wipe(shares)
  displayBackupExplanation()
  for index, mnemonic in mnemonics:
    displayBackupPhrase(index, mnemonic)
    wipe(mnemonic)
  storeSecret("main", main)
  wipe(main)
