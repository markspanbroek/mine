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

requires "sss >= 0.3.3 & < 0.4.0"
requires "mnemonic >= 0.1.4 & < 0.2.0"
requires "monocypher >= 0.3.0 & < 0.4.0"
requires "docopt >= 0.7.1 & < 0.8.0"
