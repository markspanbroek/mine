{.passL: "-framework Security".}

import os
import options

{.emit: """

#import <Foundation/Foundation.h>;
#import <Security/Security.h>;

bool setPassword(char *service, char *account, char *value, uint size) {
  @autoreleasepool{
    NSString *serviceString =
      [NSString stringWithCString:service encoding: NSUTF8StringEncoding];
    NSString *accountString =
      [NSString stringWithCString:account encoding: NSUTF8StringEncoding];
    NSData *valueData =
      [NSData dataWithBytes:value length:size];

    // Because we are using TouchID here, we need to switch to
    // the iOS version of keychain, and this can only be done
    // using the keychain entitlement, which requires a provisioning
    // profile. Provisioning profiles can only be added to an app bundle
    // and only when they are being distributed through the app store.
    // Notarization is not enough.

    SecAccessControlRef access = SecAccessControlCreateWithFlags(
      nil,
      kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
      kSecAccessControlUserPresence,
      nil
    );

    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)@{
      (id)kSecClass: (id)kSecClassGenericPassword,
      (id)kSecAttrService: serviceString,
      (id)kSecAttrAccount: accountString,
      (id)kSecAttrAccessControl: (__bridge id)access,
      (id)kSecValueData: valueData
    }, nil);

    if (result == errSecDuplicateItem) {
      result = SecItemUpdate((__bridge CFDictionaryRef)@{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: serviceString,
        (id)kSecAttrAccount: accountString,
        (id)kSecMatchLimit: (id)kSecMatchLimitOne,
        (id)kSecReturnData: @NO
      }, (__bridge CFDictionaryRef)@{
        (id)kSecValueData: valueData
      });
    }

    CFRelease(access);

    return (result == errSecSuccess);
  }
}

int getPassword(char *service, char *account, char *buffer, uint bufferSize) {
  @autoreleasepool{
    NSString *serviceString =
      [NSString stringWithCString:service encoding: NSUTF8StringEncoding];
    NSString *accountString =
      [NSString stringWithCString:account encoding: NSUTF8StringEncoding];

    CFTypeRef result = nil;

    SecItemCopyMatching((__bridge CFDictionaryRef)@{
      (id)kSecClass: (id)kSecClassGenericPassword,
      (id)kSecAttrService: serviceString,
      (id)kSecAttrAccount: accountString,
      (id)kSecMatchLimit: (id)kSecMatchLimitOne,
      (id)kSecReturnData: @YES
    }, &result);

    if (result == nil) {
      return -1;
    }

    NSData *data = (__bridge NSData *)result;
    [data getBytes:buffer length:bufferSize];
    return (int)data.length;
  }
}

bool deletePassword(char *service, char *account) {
  @autoreleasepool{
    NSString *serviceString =
      [NSString stringWithCString:service encoding: NSUTF8StringEncoding];
    NSString *accountString =
      [NSString stringWithCString:account encoding: NSUTF8StringEncoding];

    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)@{
      (id)kSecClass: (id)kSecClassGenericPassword,
      (id)kSecAttrService: serviceString,
      (id)kSecAttrAccount: accountString
    });

    return (result == errSecSuccess);
  }
}

"""}

proc setPassword(service, account, value: cstring, size: uint): bool
                {.importc, nodecl.}
proc getPassword(service, account: cstring, buffer: ptr char,
                 bufferSize: uint): int {.importc, nodecl.}
proc deletePassword(service, account: cstring): bool {.importc, nodecl.}

proc getAppName: string =
  getAppFilename().extractFilename()

proc retrieveString*(name: string): Option[string] =
  var buffer: array[4096, char]
  let size = getPassword(getAppName(), name, addr buffer[0], buffer.len.uint)
  if size == -1:
    result = none[string]()
  else:
    result = some(cast[string](buffer[0..<size]))

proc storeString*(name: string, value: string) =
  assert setPassword(getAppName(), name, value, value.len.uint)

proc deleteString*(name: string) =
  discard deletePassword(getAppName(), name)
