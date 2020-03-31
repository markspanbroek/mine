import unittest
import minepkg/secrets
import minepkg/root

suite "secrets":

  test "derives a secret from a root key":
    var root = createRootKey()
    var child = root.deriveSecret("child")
    var empty: Secret
    check child != empty
    check child != root.asArray

  test "derives a secret from another secret":
    var parent = createRootKey().deriveSecret("parent")
    var child = parent.deriveSecret("child")
    var empty: Secret
    check child != empty
    check child != parent

  test "wipes a secret":
    var secret = createRootKey().deriveSecret("secret")
    wipe(secret)
    var empty: Secret
    check secret == empty
