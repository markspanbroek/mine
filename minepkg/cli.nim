import strformat
import commandeer
import ./cli/executable
import ./cli/create
import ./cli/delete
import ./cli/restore
import ./cli/password
import ./cli/mnemonic

commandline:
  subcommand createCommand, "create":
    discard
  subcommand deleteCommand, "delete":
    discard
  subcommand restoreCommand, "restore":
    discard
  subcommand passwordCommand, "password":
    argument username, string
    argument hostname, string
    errormsg:
      fmt"Usage: {getExecutableName()} password <username> <hostname>"
  subcommand mnemonicCommand, "mnemonic":
    argument identifier, string
    errormsg:
      fmt"Usage: {getExecutableName()} mnemonic <identifier>"

proc main*() =
  if createCommand:
    create()
  elif deleteCommand:
    delete()
  elif restoreCommand:
    restore()
  elif passwordCommand:
    password(username, hostname)
  elif mnemonicCommand:
    mnemonic(identifier)
  else:
    echo:
      fmt"Usage: {getExecutableName()} " &
      "[create|delete|restore|password|mnemonic]"
