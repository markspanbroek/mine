import terminal

var output* = stdout
var input* = stdin

proc eraseCharacters(amount: int) =
  let lines = ((amount - 1) div terminalWidth()) + 1
  for i in 0..<lines:
    output.cursorUp()
    output.eraseLine()
  output.flushFile()

proc display*(secret: string): proc () =
  let length = secret.len
  output.writeLine(secret)
  output.flushFile()
  result = proc () =
    eraseCharacters(length)

proc readSecret*: string {.inline.} =
  result = input.readLine()
  eraseCharacters(result.len)
