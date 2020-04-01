import terminal

proc eraseCharacters(amount: int) =
  let lines = ((amount - 1) div terminalWidth()) + 1
  for i in 0..<lines:
    cursorUp()
    eraseLine()
  stdout.flushFile()

proc display*(secret: string): proc () =
  let length = secret.len
  stdout.writeLine(secret)
  stdout.flushFile()
  result = proc () =
    eraseCharacters(length)

proc readSecret*: string {.inline.} =
  result = stdin.readLine()
  eraseCharacters(result.len)
