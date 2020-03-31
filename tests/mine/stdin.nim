import os
import ./temp

template redirect*(body: untyped) =
  block:
    let (filename, file) = makeTempFile()
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
