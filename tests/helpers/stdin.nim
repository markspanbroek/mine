import os
import tempfile
import minepkg/console

template redirect*(body: untyped) =
  block:
    let (file, filename) = mkstemp(mode=fmRead)
    let redirected {.inject.} = open(filename, fmWrite, bufSize = 0)

    let saved = console.input
    console.input = file

    body

    console.input = saved

    close(redirected)
    close(file)
    removeFile(filename)
