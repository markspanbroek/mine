import options
import os
import parsecfg

proc getAppName: string =
  getAppFilename().extractFilename()

proc getConfigFilename: string =
  getConfigDir() / "mine.ini"

proc loadConfig: Config =
  if existsFile(getConfigFilename()):
    result = loadConfig(getConfigFilename())
  else:
    result = newConfig()

proc writeConfig(config: Config) =
  let creating = not existsFile(getConfigFilename())
  writeConfig(config, getConfigFilename())
  if creating:
    setFilePermissions(getConfigFilename(), {fpUserWrite, fpUserRead})

proc retrieveString*(name: string): Option[string] =
  let config = loadConfig()
  let value = config.getSectionValue(getAppName(), name)
  if value == "":
    result = none[string]()
  else:
    result = some(value)

proc storeString*(name: string, value: string) =
  var config = loadConfig()
  config.setSectionKey(getAppName(), name, value)
  writeConfig(config)

proc deleteString*(name: string) =
  var config = loadConfig()
  config.delSectionKey(getAppName(), name)
  writeConfig(config)
