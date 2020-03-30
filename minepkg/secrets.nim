import ./root
from monocypher import crypto_blake2b, crypto_wipe

type
  Secret* = array[64, byte]

func deriveSecret*(key: Key, name: string): Secret {.inline.} =
  crypto_blake2b(name, key.asArray)

proc wipe*(secret: Secret) {.inline.} =
  crypto_wipe(secret)
