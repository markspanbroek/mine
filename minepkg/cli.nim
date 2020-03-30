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

proc displayAndClear(secret: string) {.inline.} =
  let clear = display(secret)
  discard getCh()
  clear()

proc create =
  let root = createRootKey()
  let main = root.deriveSecret("main.0")
  let shares = root.shares(2, 3)
  wipe(root)
  let mnemonics = shares.mapIt(it.toMnemonic)
  wipe(shares)
  for mnemonic in mnemonics:
    displayAndClear(mnemonic)
    wipe(mnemonic)
  storeSecret("main", main)
  wipe(main)

proc main*() =
  if createCommand:
    create()
  else:
    let executable = getAppFilename().extractFilename()
    echo fmt"usage: {executable} create"
