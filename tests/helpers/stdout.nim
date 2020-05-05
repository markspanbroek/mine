import unittest
import os
import tempfile
import minepkg/console

template redirect*(body: untyped) =
  block:
    let (file, filename) = mkstemp(mode=fmWrite)
    let redirected {.inject.} = open(filename)

    let saved = console.output
    console.output = file

    body

    console.output = saved

    close(file)
    close(redirected)
    removeFile(filename)
