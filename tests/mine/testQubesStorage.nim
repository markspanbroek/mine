when defined(linux):

  import unittest
  import os
  import minepkg/storage/raw

  suite "qubes storage":

    setup:
      storeString("someName", "some value")

    teardown:
      deleteString("someName")

    test "creates config file with correct permissions":
      let filename = getConfigDir() / "mine.ini"
      check existsFile(filename)
      check getFilePermissions(filename) == {fpUserRead, fpUserWrite}
