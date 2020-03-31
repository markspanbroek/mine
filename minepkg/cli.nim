import strformat
import commandeer
import ./cli/executable
import ./cli/create
import ./cli/delete
import ./cli/password

commandline:
  subcommand createCommand, "create":
    discard
  subcommand deleteCommand, "delete":
    discard
  subcommand passwordCommand, "password":
    argument username, string
    argument hostname, string
    errormsg:
      fmt"Usage: {getExecutableName()} password <username> <hostname>"

proc main*() =
  if createCommand:
    create()
  elif deleteCommand:
    delete()
  elif passwordCommand:
    password(username, hostname)
  else:
    echo fmt"Usage: {getExecutableName()} [create|delete|password]"
