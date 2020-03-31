import strformat
import commandeer
import ./cli/executable
import ./cli/create
import ./cli/delete

commandline:
  subcommand createCommand, "create":
    discard
  subcommand deleteCommand, "delete":
    discard

proc main*() =
  if createCommand:
    create()
  elif deleteCommand:
    delete()
  else:
    echo fmt"usage: {getExecutableName()} [create|delete]"
