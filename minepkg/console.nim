import terminal

proc display*(secret: string): proc () =
  let lines = ((secret.len - 1) div terminalWidth()) + 1
  stdout.write(secret)
  stdout.flushFile()
  result = proc () =
    for i in 0..<lines:
      if i > 0:
        cursorUp()
      eraseLine()
    stdout.flushFile()
