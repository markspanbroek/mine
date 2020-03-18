import unittest
import mine/secrets
import mine/root

test "derives a secret":
  var root = createRootKey()
  var child = root.deriveSecret("child")
  var empty: Secret
  check child != empty
  check child != root.asArray

test "wipes a secret":
  var secret = createRootKey().deriveSecret("secret")
  wipe(secret)
  var empty: Secret
  check secret == empty
