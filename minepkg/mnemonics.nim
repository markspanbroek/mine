import mnemonic
import ./secrets
import ./strings

export wipe

proc toMnemonic*(secret: Secret): string {.inline.} =
  encode(secret[0..<32])
