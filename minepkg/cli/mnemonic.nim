import strformat
import terminal
import ./mainsecret
import ../mnemonics
import ../secrets
import ../console

proc displayBlankedMnemonic* =
  echo:
    "***** ***** ***** ***** ***** ***** ***** ***** ***** ***** " &
    "***** ***** ***** ***** ***** ***** ***** ***** ***** ***** " &
    "***** ***** ***** ***** *****"

proc displayMnemonic(identifier, mnemonic: string) =
  if stdout.isatty:
    echo &"Displaying mnemonic for {identifier}. Press a key to continue\n"
    let clear = display(mnemonic)
    discard getCh()
    clear()
    displayBlankedMnemonic()
  else:
    echo mnemonic

proc mnemonic*(identifier: string, version: uint) =
  let main = getMainSecret()
  let mnemonics = deriveSecret(main, "mnemonics")
  wipe(main)
  let mnemonic = deriveSecret(mnemonics, identifier, version).toMnemonic
  wipe(mnemonics)
  displayMnemonic(identifier, mnemonic)
  wipe(mnemonic)
