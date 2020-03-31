import terminal

proc eraseCharacters(amount: int) =
  let lines = ((amount - 1) div terminalWidth()) + 1
  for i in 0..<lines:
    if i > 0:
      cursorUp()
    eraseLine()
  stdout.flushFile()

proc display*(secret: string): proc () =
  let length = secret.len
  stdout.write(secret)
  stdout.flushFile()
  result = proc () = eraseCharacters(length)

proc readSecret*: string {.inline.} =
  result = stdin.readLine()
  cursorUp()
  eraseCharacters(result.len)
