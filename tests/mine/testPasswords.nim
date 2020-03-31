import unittest
import strutils
import base64
import re
import sequtils
import minepkg/root
import minepkg/secrets
import minepkg/passwords

suite "passwords":

  test "derives password from secret":
    let secret = createRootKey().deriveSecret("secret")
    let expected = encode(secret)
      .replace(re"[^0-9A-Za-z]")
      .substr(0, 11)
      .findAll(re".{3}")
      .join("-")
    check secret.toPassword == expected

  test "wipes a password":
    var password = "some password"
    wipe(password)
    check cast[seq[byte]](password).allIt(it == 0)
