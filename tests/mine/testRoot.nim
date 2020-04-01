import unittest
import mine

suite "root keys":

  test "creates a random root key":
    check createRootKey() != createRootKey()

  test "wipes a root key":
    let key = createRootKey()
    wipe(key)
    var empty: Key
    check key == empty
