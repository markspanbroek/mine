import unittest
import strutils
import strformat
import terminal
import ../helpers/stdout
import ../helpers/stdin
import minepkg/console

if defined(posix):

  suite "console":

    const ansiEraseLine = &"\e[2K\e[1G"
    const ansiCursorUp = &"\e[1A"
    const ansiErasePreviousLine = ansiCursorUp & ansiEraseLine

    let secret = "some secret"

    test "displays a secret":
      stdout.redirect:
        discard display(secret)
        check redirected.readAll() == secret & "\n"

    test "clears line after displaying a secret":
      stdout.redirect:
        let clear = display(secret)
        clear()
        check redirected.readAll() == secret & "\n" & ansiErasePreviousLine

    test "clears multiple lines after displaying a secret":
      let threeLines = "123".repeat(terminalWidth())
      stdout.redirect:
        let clear = display(threeLines)
        clear()
        check redirected.readAll() ==
          threeLines & "\n" & ansiErasePreviousLine.repeat(3)

    test "reads a secret":
      stdin.redirect:
        redirected.writeLine(secret)
        check readSecret() == secret

    test "clears line after reading a secret":
      stdin.redirect:
        redirected.writeLine(secret)
        stdout.redirect:
          discard readSecret()
          check redirected.readAll() == ansiErasePreviousLine

    test "clears multiple lines after reading a secret":
      let threeLines = "123".repeat(terminalWidth())
      stdin.redirect:
        redirected.writeLine(threeLines)
        stdout.redirect:
          discard readSecret()
          check redirected.readAll() == ansiErasePreviousLine.repeat(3)
