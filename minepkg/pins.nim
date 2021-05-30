import sequtils
import strutils
import secrets
import strings

export wipe

proc toPin*(secret: Secret, length: range[4..12] = 4): string =
  result = secret
    .filterIt(it < 200)
    .mapIt(it mod 100)
    .mapIt(intToStr(it.int, 2))
    .join()
    .substr(0, length-1)
  doAssert result.len == length
