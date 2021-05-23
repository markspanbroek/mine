import secrets
import storage/raw
import base64
import options

proc retrieveSecret*(name: string): Option[Secret] =
  let retrieved = retrieveString(name)
  if retrieved.isNone:
    return none(Secret)
  var decoded = decode(retrieved.get())
  var secret: Secret
  assert len(decoded) == len(secret)
  copyMem(addr secret[0], addr decoded[0], len(secret))
  result = some(secret)

proc storeSecret*(name: string, secret: Secret) =
  assert retrieveSecret(name).isNone
  storeString(name, encode(secret))

proc deleteSecret*(name: string) =
  deleteString(name)

proc storePassword*(username, host: string, version: int) =
  discard

proc retrievePasswords*: seq[seq[string]] =
  discard
