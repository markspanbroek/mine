import sss
import monocypher except Key

export Key, Share, shares, asArray

type
  Secret* = array[64, byte]

func createRootKey*: Key {.inline.} =
  randomKey()

func restoreRootKey*(shares: openArray[Share]): Key {.inline.} =
  combine(shares)

func deriveSecret*(key: Key, name: string): Secret {.inline.} =
  crypto_blake2b(name, key.asArray)

proc wipe*(key: Key) {.inline.} =
  crypto_wipe(key.asArray)

proc wipe*(share: Share) {.inline.} =
  crypto_wipe(share)

proc wipe*(secret: Secret) {.inline.} =
  crypto_wipe(secret)

proc wipe*(shares: openArray[Share]) {.inline.} =
  for i in shares.low..shares.high:
    wipe(shares[i])

func `==`*(a, b: Key): bool =
  crypto_verify(a.asArray, b.asArray)
