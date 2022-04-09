import std/osproc
import std/strutils
import std/options
import std/json

proc exec(command: string): string =
  execProcess(command)

iterator exec(command: string): string =
  let process = startProcess(command, options={poEvalCommand})
  for line in process.lines:
    yield line
  process.close

type
  BitWarden = object
    items*: seq[Item]
  Item = object
    `type`*: int
    name*: string
    login*: Login
  Login = object
    username*: Option[string]
    password*: Option[string]
    notes*: Option[string]

proc `%`(login: Login): JsonNode =
  result = newJObject()
  if login.username.isSome:
    result["username"] = newJString(login.username.get())
  if login.password.isSome:
    result["password"] = newJString(login.password.get())
  if login.notes.isSome:
    result["notes"] = newJString(login.notes.get())

if isMainModule:
  var bitwarden: Bitwarden
  for command in exec("mine saved"):
    let arguments = command.split()
    var output = exec(command)
    removeSuffix output
    case arguments[1]
    of "password":
      bitwarden.items.add(Item(`type`: 1, name: arguments[3], login: Login(username: some arguments[2], password: some output)))
    of "mnemonic", "pin":
      bitwarden.items.add(Item(`type`: 1, name: arguments[2], login: Login(password: some output)))
    of "wifi":
      bitwarden.items.add(Item(`type`: 1, name: arguments[2], login: Login(password: some output, notes: some "WiFi")))
    else:
      discard
  echo %bitwarden

# reference: https://bitwarden.com/help/condition-bitwarden-import/
