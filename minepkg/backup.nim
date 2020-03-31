import strutils
from sss import Share, shares, combine
import mnemonic
import mnemonic/words
from monocypher import crypto_wipe
import ./root
import ./strings

export Share, shares, wipe

func restoreRootKey*(shares: openArray[Share]): Key {.inline.} =
  combine(shares)

proc toMnemonic*(share: Share): string {.inline.} =
  indexToWord(share[0]) & " " & encode(share[1..^1])

proc mnemonicToShare*(mnemonic: string): Share {.inline.} =
  let words = mnemonic.split()
  let number = wordToIndex(words[0])
  assert number <= high(uint8).uint16
  result[0] = number.uint8
  result[1..^1] = decode(words[1..^1].join(" "))

proc wipe*(share: Share) {.inline.} =
  crypto_wipe(share)

proc wipe*(shares: openArray[Share]) {.inline.} =
  for i in shares.low..shares.high:
    wipe(shares[i])
