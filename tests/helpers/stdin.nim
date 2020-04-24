import os
import tempfile

template redirect*(body: untyped) =
  block:
    let (file, filename) = mkstemp(mode=fmRead)
    defer:
      close(file)
      removeFile(filename)

    let redirected {.inject.} = open(filename, fmWrite, bufSize = 0)
    defer:
      close(redirected)

    let saved = stdin
    stdin = file

    body

    stdin = saved
