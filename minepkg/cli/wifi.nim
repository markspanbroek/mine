import strformat
import terminal
import ../secrets
import ../passwords
import ../console
import ./mainsecret

proc displayPassword(ssid, password: string) =
  echo:
    fmt"Displaying password for WiFi access point {ssid}. " &
    "Press a key to continue.\n"
  let clear = display(password)
  discard getCh()
  clear()
  echo "***-***-***-***"

proc wifi*(ssid: string, version: uint) =
  let main = getMainSecret()
  let passwords = deriveSecret(main, "wifi")
  wipe(main)
  let secret = deriveSecret(passwords, ssid, version)
  wipe(passwords)
  let password = secret.toPassword
  wipe(secret)
  displayPassword(ssid, password)
  wipe(password)
