import unittest
import mine

suite "keys and secrets":

  test "creates a random root key":
    check createRootKey() != createRootKey()

  test "creates shamir shares from the root key":
    let key = createRootKey()
    let shares = key.shares(2, 3)
    check len(shares) == 3

  test "restores a root key from shamir shares":
    let key = createRootKey()
    let shares = key.shares(2, 3)
    let restored = restoreRootKey(shares[0..1])
    check restored == key

  test "derives a secret":
    var root = createRootKey()
    var child = root.deriveSecret("child")
    var empty: Secret
    check child != empty
    check child != root.asArray

suite "wiping":

  test "wipes a root key":
    var key = createRootKey()
    wipe(key)
    var empty: Key
    check key == empty

  test "wipes a share":
    var shares = createRootKey().shares(2, 3)
    wipe(shares[0])
    var empty: Share
    check shares[0] == empty

  test "wipes multiple shares":
    var shares = createRootKey().shares(2, 3)
    wipe(shares)
    var empty: array[3, Share]
    check shares == empty

  test "wipes a secret":
    var secret = createRootKey().deriveSecret("secret")
    wipe(secret)
    var empty: Secret
    check secret == empty
