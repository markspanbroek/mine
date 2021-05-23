import docopt
import ./cli/create
import ./cli/delete
import ./cli/restore
import ./cli/password
import ./cli/mnemonic
import ./cli/wifi
import ./cli/version

const usage = """
Mine̼, a password and key manager

Usage:
  mine create
  mine delete
  mine restore
  mine password <username> <hostname> [-n <version>] [--save]
  mine mnemonic <name> [-n <version>] [--save]
  mine wifi <ssid> [-n <version>] [--save]
  mine list
  mine -h | --help

Commands:
  create    Create a new main secret
  delete    Delete the main secret
  restore   Restore a main secret from backup phrases
  password  Show the derived password for a username and hostname
  mnemonic  Show the derived mnemonic for a crypto wallet
  wifi      Show the derived passwords for a wifi access point
  list      Shows a list of all saved passwords, mnemonics, ...

Options:
  -h, --help  Show this screen
  -n          Specify the version number of a password or mnemonic
  --save      Remembers this password, mnemonic, ...

Examples:
  mine create
  mine password octo github.com
  mine mnemonic ethereum
"""

proc main*() =
  let args = docopt(usage)
  if args["create"]:
    create()
  elif args["delete"]:
    delete()
  elif args["restore"]:
    restore()
  elif args["password"]:
    password($args["<username>"], $args["<hostname>"], args.version)
  elif args["mnemonic"]:
    mnemonic($args["<name>"], args.version)
  elif args["wifi"]:
    wifi($args["<ssid>"], args.version)
