from sss import Key, randomKey, asArray
from monocypher import crypto_wipe, crypto_verify

export Key, asArray

func createRootKey*: Key {.inline.} =
  randomKey()

proc wipe*(key: Key) {.inline.} =
  crypto_wipe(key.asArray)

func `==`*(a, b: Key): bool =
  crypto_verify(a.asArray, b.asArray)
