import sequtils
import strformat
import os
import commandeer
import terminal
import ./root
import ./secrets
import ./backup
import ./displaying
import ./storage

commandline:
  subcommand createCommand, "create":
    discard

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

proc create =
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

proc main*() =
  if createCommand:
    create()
  else:
    let executable = getAppFilename().extractFilename()
    echo fmt"usage: {executable} create"
