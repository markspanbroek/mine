version = "0.4.0"
author = "Mark Spanbroek"
description = "Mine̼, a password and key manager"
license = "MIT"

bin = @["mine", "mine_export"]

if defined(macosx):
  backend = "objc"
else:
  backend = "c"

task test, "Runs the test suite":
  exec "nim " & backend & " --run --path:. --define:test tests/testRunner"

requires "nim >= 1.0.6 & < 2.0.0"
requires "sss >= 0.3.2 & < 0.4.0"
requires "mnemonic >= 0.1.3 & < 0.2.0"
requires "monocypher >= 0.2.0 & < 0.3.0"
requires "docopt >= 0.6.8 & < 0.7.0"
requires "tempfile >= 0.1.7 & < 0.2.0"
