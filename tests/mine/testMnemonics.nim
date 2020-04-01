import unittest
import sequtils
import mnemonic
import mine

suite "mnemonics":

  test "derives a bip-39 mnemonic from a secret":
    let secret = createRootKey().deriveSecret("secret")
    check secret.toMnemonic == mnemonic.encode(secret[0..<32])

  test "mnemonic can be wiped":
    let mnemonic = createRootKey().deriveSecret("secret").toMnemonic
    wipe(mnemonic)
    check cast[seq[byte]](mnemonic).allIt(it == 0)
