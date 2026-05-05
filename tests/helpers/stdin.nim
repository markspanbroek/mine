import std/os
import std/tempfiles
import minepkg/console

template redirect*(body: untyped) =
  block:
    let (file, filename) = createTempFile("mine", "")
    let redirected {.inject.} = open(filename, fmWrite, bufSize = 0)

    let saved = console.input
    console.input = file

    body

    console.input = saved

    close(redirected)
    close(file)
    removeFile(filename)
