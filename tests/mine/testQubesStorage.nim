import unittest
import os
import minepkg/storage/raw

when defined(linux):

  suite "qubes storage":

    setup:
      storeString("someName", "some value")

    teardown:
      deleteString("someName")

    test "creates config file with correct permissions":
      let filename = getConfigDir() / "mine.ini"
      check existsFile(filename)
      check getFilePermissions(filename) == {fpUserRead, fpUserWrite}
