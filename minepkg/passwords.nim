import strutils
import base64
import re
import ./secrets

func toPassword*(secret: Secret): string =
  result = base64.encode(secret)
  result = result.replace(re"[^0-9A-Za-z]")
  result = result[0..<12]
  result = result.findAll(re".{3}").join("-")
