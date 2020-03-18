import unittest
import mine/storage
import mine/root
import mine/secrets
import options
import keyring
import os
import base64

suite "storage":

  let name = "some name"
  let secret = createRootKey().deriveSecret(name)

  teardown:
    deleteSecret(name)

  test "stores and retrieves a secret":
    storeSecret(name, secret)
    check retrieveSecret(name) == some(secret)

  test "signals when a secret could not be retrieved":
    check retrieveSecret("non-existing").isNone

  test "refuses to retrieve a secret that's not base64":
    setPassword(getAppFilename().extractFilename(), name, "not base64!")
    expect Exception:
      discard retrieveSecret(name)

  test "refuses to retrieve a secret of the wrong length":
    setPassword(getAppFilename().extractFilename(), name, encode("too short"))
    expect Exception:
      discard retrieveSecret(name)

  test "deletes a secret":
    storeSecret(name, secret)
    deleteSecret(name)
    check retrieveSecret(name).isNone

  test "refuses to overwrite a secret":
    storeSecret(name, secret)
    expect Exception:
      storeSecret(name, secret)
