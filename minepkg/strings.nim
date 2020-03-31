import monocypher

proc wipe*(s: string) {.inline.} =
  crypto_wipe(cast[seq[byte]](s))
