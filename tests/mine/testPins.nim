import unittest
import sequtils
import strutils
import mine

suite "PINs":

  test "derives PINs of specific length from secret":
    let secret = createRootKey().deriveSecret("secret")
    check secret.toPin.len == 4
    check secret.toPin(6).len == 6
    check secret.toPin(12).len == 12

  test "derived PINs follow a random distribution":
    var total: float = 0
    for _ in 0..<1000:
      let secret = createRootKey().deriveSecret("secret")
      total += parseFloat secret.toPin
    let average = total / 1000
    check 4500 < average and average < 5500

  test "wipes a PIN":
    let pin = "1234"
    wipe(pin)
    check cast[seq[byte]](pin).allIt(it == 0)
