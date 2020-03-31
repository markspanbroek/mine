import strformat
import options
import terminal
import ../storage
import ../secrets
import ../passwords
import ../displaying
import ./executable

proc displayErrorNoMainSecret =
  stderr.writeLine:
    "No main secret found. Please create one first using " &
    fmt"'{getExecutableName()} create'"

proc getMainSecret: Secret =
  let main = retrieveSecret("main")
  if main.isSome:
    result = main.get()
  else:
    displayErrorNoMainSecret()
    quit(QuitFailure)

proc displayPassword(username, hostname, password: string) =
  echo:
    fmt"Displaying password for {username} at {hostname}. " &
    "Press a key to continue.\n"
  let clear = display(password)
  discard getCh()
  clear()
  echo "***-***-***-***"

proc password*(username, hostname: string) =
  let main = getMainSecret()
  let passwords = deriveSecret(main, "passwords")
  wipe(main)
  let password = deriveSecret(passwords, fmt"{username}@{hostname}").toPassword
  wipe(passwords)
  displayPassword(username, hostname, password)
  wipe(password)
