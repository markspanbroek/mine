import strformat
import terminal
import ../secrets
import ../pins
import ../console
import ./mainsecret

proc displayPin(identifier, pin: string) =
  if stdout.isatty:
    echo &"Displaying PIN for {identifier}. Press a key to continue\n"
    let clear = display(pin)
    discard getCh()
    clear()
    echo "****"
  else:
    echo pin

proc pin*(identifier: string, length: range[4..12], version: uint) =
  let main = getMainSecret()
  let pins = main.deriveSecret("pins")
  wipe(main)
  let secret = pins.deriveSecret(identifier, version)
  wipe(pins)
  let pin = secret.toPin(length)
  wipe(secret)
  displayPin(identifier, pin)
  wipe(pin)
