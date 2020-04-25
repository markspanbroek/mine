import docopt
import ./cli/create
import ./cli/delete
import ./cli/restore
import ./cli/password
import ./cli/mnemonic

const usage = """
Mine̼, a password and key manager

Usage:
  mine create
  mine delete
  mine restore
  mine password <username> <password>
  mine mnemonic <identifier>
  mine -h | --help

Options:
  -h, --help  Show this screen
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
    password($args["<username>"], $args["<password>"])
  elif args["mnemonic"]:
    mnemonic($args["<identifier>"])
