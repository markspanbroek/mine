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
  mine mnemonic <identifier>
  mine password <username> <hostname>
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
    password($args["<username>"], $args["<hostname>"])
  elif args["mnemonic"]:
    mnemonic($args["<identifier>"])
