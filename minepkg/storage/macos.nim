import os
import keyring

proc getAppName: string =
  getAppFilename().extractFilename()

proc retrieveString*(name: string): Option[string] =
  getPassword(getAppName(), name)

proc storeString*(name: string, value: string) =
  setPassword(getAppName(), name, value)

proc deleteString*(name: string) =
  deletePassword(getAppName(), name)
