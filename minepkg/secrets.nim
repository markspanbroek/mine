import ./root
from monocypher import crypto_blake2b, crypto_wipe

type
  Secret* = array[64, byte]

func deriveSecret*(key: Key, name: string): Secret {.inline.} =
  crypto_blake2b(name, key.asArray)

func deriveSecret*(secret: Secret, name: string): Secret {.inline.} =
  crypto_blake2b(name, secret)

proc wipe*(secret: Secret) {.inline.} =
  crypto_wipe(secret)
