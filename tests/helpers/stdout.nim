import unittest
import os
import tempfile
import minepkg/console

template redirect*(body: untyped) =
  block:
    let (file, filename) = mkstemp(mode=fmWrite)
    defer:
      close(file)
      removeFile(filename)

    let redirected {.inject.} = open(filename)
    defer:
      close(redirected)

    let saved = console.output
    console.output = file

    body

    console.output = saved
