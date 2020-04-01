import os
import posix_utils

proc makeTempFile*: (string, File) =
  result = mkstemp getAppFileName().extractFileName()
