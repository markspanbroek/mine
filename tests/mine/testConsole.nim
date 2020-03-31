import unittest
import strutils
import strformat
import terminal
import ./stdout
import minepkg/console

suite "console":

  const ansiEraseLine = &"\e[2K\e[1G"
  const ansiCursorUp = &"\e[1A"

  let secret = "some secret"

  test "displays a secret":
    stdout.redirect:
      discard display(secret)
      check redirected.readAll() == secret

  test "clears line after displaying a secret":
    stdout.redirect:
      let clear = display(secret)
      clear()
      check redirected.readAll() == secret & ansiEraseLine

  test "clears multiple lines after displaying a secret":
    let threeLines = "123".repeat(terminalWidth())
    stdout.redirect:
      let clear = display(threeLines)
      clear()
      check redirected.readAll() ==
        threeLines &
        ansiEraseLine &
        ansiCursorUp & ansiEraseLine &
        ansiCursorUp & ansiEraseLine
