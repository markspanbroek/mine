import unittest
import mine/backup
import mine/root

suite "backup and restore":

  test "creates shamir shares from the root key":
    let key = createRootKey()
    let shares = key.shares(2, 3)
    check len(shares) == 3

  test "restores a root key from shamir shares":
    let key = createRootKey()
    let shares = key.shares(2, 3)
    let restored = restoreRootKey(shares[0..1])
    check restored == key

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

