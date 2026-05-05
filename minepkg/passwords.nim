import std/strutils
import std/base64
import ./secrets
import ./strings

export wipe

proc toPassword*(secret: Secret): string =
  var password: string = newStringOfCap(15)
  for character in base64.encode(secret):
    if password.len == 15:
      break
    if password.len in {3, 7, 11}:
      password &= "-"
    if character in Letters + Digits:
      password &= character
  password
