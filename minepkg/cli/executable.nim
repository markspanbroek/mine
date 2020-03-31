import os

proc getExecutableName*(): string =
  getAppFilename().extractFilename()
