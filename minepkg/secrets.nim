import strformat
from monocypher import crypto_blake2b, crypto_wipe
import ./root

type
  Secret* = array[64, byte]

func combine(name: string, version: uint): string =
  fmt"{name}|{version}"

func deriveSecret*(key: Key, name: string, version: uint = 0): Secret {.inline.} =
  crypto_blake2b(combine(name, version), key.asArray)

func deriveSecret*(secret: Secret, name: string, version: uint = 0): Secret {.inline.} =
  crypto_blake2b(combine(name, version), secret)

proc wipe*(secret: Secret) {.inline.} =
  crypto_wipe(secret)
