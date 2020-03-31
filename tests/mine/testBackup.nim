import unittest
import sequtils
import mnemonic
import mnemonic/words
import minepkg/backup
import minepkg/root

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

  test "converts a shamir share to a mnemonic":
    let shares = createRootKey().shares(2, 3)
    let number = shares[0][0]
    let bytes = shares[0][1..^1]
    check shares[0].toMnemonic == indexToWord(number) & " " & encode(bytes)

  test "converts a mnemonic into a shamir share":
    let shares = createRootKey().shares(2, 3)
    let mnemonic = shares[0].toMnemonic
    check mnemonicToShare(mnemonic) == shares[0]

  test "refuses to convert a mnemonic of the wrong length":
    let shares = createRootKey().shares(2, 3)
    let mnemonic = indexToWord(1) & " " & encode(shares[0][1..16])
    expect Exception:
      discard mnemonicToShare(mnemonic)

  test "refuses to convert a mnemonic with a wrong first word":
    let shares = createRootKey().shares(2, 3)
    let mnemonic = indexToWord(256) & " " & encode(shares[0][1..^1])
    expect Exception:
      discard mnemonicToShare(mnemonic)

  test "wipes a share":
    let shares = createRootKey().shares(2, 3)
    wipe(shares[0])
    var empty: Share
    check shares[0] == empty

  test "wipes multiple shares":
    let shares = createRootKey().shares(2, 3)
    wipe(shares)
    var empty: array[3, Share]
    check shares == empty

  test "wipes a (mnemonic) string":
    let mnemonic = "some mnemonic"
    wipe(mnemonic)
    check cast[seq[byte]](mnemonic).allIt(it == 0)
