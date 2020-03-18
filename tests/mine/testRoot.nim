import unittest
import mine/root

suite "root keys":

  test "creates a random root key":
    check createRootKey() != createRootKey()

  test "wipes a root key":
    var key = createRootKey()
    wipe(key)
    var empty: Key
    check key == empty
