import unittest
import os
import posix_utils

proc makeTempFile: (string, File) =
  result = mkstemp getAppFileName().extractFileName()

template redirect*(body: untyped) =
  block:
    let (filename, file) = makeTempFile()
    defer:
      close(file)
      removeFile(filename)

    let redirected {.inject.} = open(filename)
    defer:
      close(redirected)

    let saved = stdout
    stdout = file

    template check(conditions: untyped) {.inject.} =
      stdout = saved
      unittest.check(conditions)
      stdout = file

    body

    stdout = saved
