import os
import strutils
import sequtils
import sugar
import docopt
import ./cli/create
import ./cli/delete
import ./cli/restore
import ./cli/password
import ./cli/pin
import ./cli/mnemonic
import ./cli/wifi
import ./cli/version
import ./cli/length

const usage = """
Mine̼, a password and key manager

Usage:
  mine create
  mine delete
  mine restore
  mine password <username> <hostname> [-n <version>] [-s]
  mine pin <name> [-l <length>] [-n <version>] [-s]
  mine mnemonic <name> [-n <version>] [-s]
  mine wifi <ssid> [-n <version>] [-s]
  mine saved
  mine -h | --help

Commands:
  create    Create a new main secret
  delete    Delete the main secret
  restore   Restore a main secret from backup phrases
  password  Show the derived password for a username and hostname
  pin       Show the derived PIN
  mnemonic  Show the derived mnemonic for a crypto wallet
  wifi      Show the derived passwords for a wifi access point
  saved     Show previously saved passwords, pins and mnemonics

Options:
  -h, --help  Show this screen
  -n          Specify the version number of a password, PIN or mnemonic
  -s          Remember this password, pin or mnemonic by saving to file
  -l          Specify the length of the PIN [default: 4]

Examples:
  mine create
  mine password octo github.com
  mine mnemonic ethereum
"""

proc main*() =
  let args = docopt(usage)

  if args["-s"]:
    let file = open(getConfigDir() / "mine-passwords", fmAppend)
    file.write("mine ")
    file.write(commandLineParams().filter(param => param != "-s").join(" "))
    file.write("\n")
    file.close()

  if args["create"]:
    create()
  elif args["delete"]:
    delete()
  elif args["restore"]:
    restore()
  elif args["password"]:
    password($args["<username>"], $args["<hostname>"], args.version)
  elif args["pin"]:
    pin($args["<name>"], args.length, args.version)
  elif args["mnemonic"]:
    mnemonic($args["<name>"], args.version)
  elif args["wifi"]:
    wifi($args["<ssid>"], args.version)
  elif args["saved"]:
    for line in (getConfigDir() / "mine-passwords").lines:
      echo line

