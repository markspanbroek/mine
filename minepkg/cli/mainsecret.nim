import strformat
import options
import ./executable
import ../secrets
import ../storage

proc displayErrorNoMainSecret =
  stderr.writeLine:
    "No main secret found. Please create one first using " &
    fmt"'{getExecutableName()} create'"

proc getMainSecret*: Secret =
  let main = retrieveSecret("main")
  if main.isSome:
    result = main.get()
  else:
    displayErrorNoMainSecret()
    quit(QuitFailure)
