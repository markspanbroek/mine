import ./secrets
import keyring
import os
import base64
import options

proc getAppName: string =
  getAppFilename().extractFilename()

proc retrieveSecret*(name: string): Option[Secret] =
  let retrieved = getPassword(getAppName(), name)
  if retrieved.isNone:
    return none(Secret)
  var decoded = decode(retrieved.get())
  var secret: Secret
  assert len(decoded) == len(secret)
  copyMem(addr secret[0], addr decoded[0], len(secret))
  result = some(secret)

proc storeSecret*(name: string, secret: Secret) =
  assert retrieveSecret(name).isNone
  setPassword(getAppName(), name, encode(secret))

proc deleteSecret*(name: string) =
  deletePassword(getAppName(), name)
