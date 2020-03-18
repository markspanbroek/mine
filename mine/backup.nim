import ./root
from sss import Share, shares, combine
from monocypher import crypto_wipe

export Share, shares

func restoreRootKey*(shares: openArray[Share]): Key {.inline.} =
  combine(shares)

proc wipe*(share: Share) {.inline.} =
  crypto_wipe(share)

proc wipe*(shares: openArray[Share]) {.inline.} =
  for i in shares.low..shares.high:
    wipe(shares[i])

