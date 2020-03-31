import unittest
import strutils
import base64
import re
import minepkg/root
import minepkg/secrets
import minepkg/passwords

suite "Converting secrets to passwords":

  test "derives password from secret":
    let secret = createRootKey().deriveSecret("secret")
    let expected = encode(secret)
      .replace(re"[^0-9A-Za-z]")
      .substr(0, 11)
      .findAll(re".{3}")
      .join("-")
    check secret.toPassword == expected
