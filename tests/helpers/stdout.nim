import std/unittest
import std/os
import std/tempfiles
import minepkg/console

template redirect*(body: untyped) =
  block:
    let (file, filename) = createTempFile("mine", "")
    let redirected {.inject.} = open(filename)

    let saved = console.output
    console.output = file

    body

    console.output = saved

    close(file)
    close(redirected)
    removeFile(filename)
