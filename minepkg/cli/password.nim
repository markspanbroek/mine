import strformat
import options
import terminal
import ../secrets
import ../passwords
import ../console
import ./mainsecret

proc displayPassword(username, hostname, password: string) =
  echo:
    fmt"Displaying password for {username} at {hostname}. " &
    "Press a key to continue.\n"
  let clear = display(password)
  discard getCh()
  clear()
  echo "***-***-***-***"

proc password*(username, hostname: string) =
  let main = getMainSecret()
  let passwords = deriveSecret(main, "passwords")
  wipe(main)
  let password = deriveSecret(passwords, fmt"{username}@{hostname}").toPassword
  wipe(passwords)
  displayPassword(username, hostname, password)
  wipe(password)
