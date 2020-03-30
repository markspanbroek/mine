import unittest
import strutils
import strformat
import terminal
import ./stdout
import minepkg/displaying

suite "displaying secrets on a terminal":

  const ansiEraseLine = &"\e[2K\e[1G"
  const ansiCursorUp = &"\e[1A"

  let secret = "some secret"

  test "displays a secret":
    stdout.redirect:
      discard display(secret)
      check redirected.readAll() == secret

  test "clears line afterwards":
    stdout.redirect:
      let clear = display(secret)
      clear()
      check redirected.readAll() == secret & ansiEraseLine

  test "clears multiple lines":
    let threeLines = "123".repeat(terminalWidth())
    stdout.redirect:
      let clear = display(threeLines)
      clear()
      check redirected.readAll() ==
        threeLines &
        ansiEraseLine &
        ansiCursorUp & ansiEraseLine &
        ansiCursorUp & ansiEraseLine
