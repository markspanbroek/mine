import strutils
import strformat
import tables

proc version*(args: Table): uint =
  if args["<version>"]:
    let version = $args["<version>"]
    try:
      result = parseUInt(version)
    except ValueError:
      stderr.writeLine fmt"'{version}' is not a positive number"
      quit(QuitFailure)
