import unittest
import mine

suite "secrets":

  test "derives a secret from a root key":
    let root = createRootKey()
    let child = root.deriveSecret("child")
    var empty: Secret
    check child != empty
    check child != root.asArray

  test "derives a secret from another secret":
    let parent = createRootKey().deriveSecret("parent")
    let child = parent.deriveSecret("child")
    var empty: Secret
    check child != empty
    check child != parent

  test "can derive different versions of a secret":
    let root = createRootKey()
    check root.deriveSecret("child", 0) == root.deriveSecret("child")
    check root.deriveSecret("child", 1) != root.deriveSecret("child")
    let parent = root.deriveSecret("parent")
    check parent.deriveSecret("child", 0) == parent.deriveSecret("child")
    check parent.deriveSecret("child", 1) != parent.deriveSecret("child")

  test "wipes a secret":
    let secret = createRootKey().deriveSecret("secret")
    wipe(secret)
    var empty: Secret
    check secret == empty
