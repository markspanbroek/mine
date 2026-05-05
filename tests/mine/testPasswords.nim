import std/unittest
import std/strutils
import std/base64
import std/sequtils
import mine

suite "passwords":

  test "derives password from secret":
    let secret = createRootKey().deriveSecret("secret")
    let encoded = encode(secret)
    let cleaned = encoded.filterIt(it in Letters or it in Digits)
    let truncated = cleaned[0..<12]
    let groups = truncated.distribute(4)
    var expected: string
    for group in groups:
      if expected.len > 0:
        expected &= "-"
      for character in group:
        expected &= character
    check secret.toPassword == expected

  test "wipes a password":
    let secret = createRootKey().deriveSecret("secret")
    let password = secret.toPassword
    wipe(password)
    check cast[seq[byte]](password).allIt(it == 0)
