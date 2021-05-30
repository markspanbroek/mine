import strutils
import strformat
import tables

proc invalidLength =
  stderr.writeLine fmt"PIN length is not a number between 4 and 12"
  quit(QuitFailure)

proc length*(args: Table): uint =
  if args["<length>"]:
    let length = $args["<length>"]
    try:
      result = parseUInt(length)
    except ValueError:
      invalidLength()
    if result < 4 or result > 12:
      invalidLength()
  else:
    result = 4
