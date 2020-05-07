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

    OSStatus result = SecItemAdd(@{
      (id)kSecClass: (id)kSecClassGenericPassword,
      (id)kSecAttrService: serviceString,
      (id)kSecAttrAccount: accountString,
      (id)kSecValueData: valueData
    }, nil);

    if (result == errSecDuplicateItem) {
      result = SecItemUpdate(@{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: serviceString,
        (id)kSecAttrAccount: accountString,
        (id)kSecMatchLimit: (id)kSecMatchLimitOne,
        (id)kSecReturnData: @NO
      }, @{
        (id)kSecValueData: valueData
      });
    }

    return (result == errSecSuccess);
  }
}

int getPassword(char *service, char *account, char *buffer, uint bufferSize) {
  @autoreleasepool{
    NSString *serviceString =
      [NSString stringWithCString:service encoding: NSUTF8StringEncoding];
    NSString *accountString =
      [NSString stringWithCString:account encoding: NSUTF8StringEncoding];

    NSData *result;

    SecItemCopyMatching(@{
      (id)kSecClass: (id)kSecClassGenericPassword,
      (id)kSecAttrService: serviceString,
      (id)kSecAttrAccount: accountString,
      (id)kSecMatchLimit: (id)kSecMatchLimitOne,
      (id)kSecReturnData: @YES
    }, &result);

    if (result == nil) {
      return -1;
    }

    [result getBytes:buffer length:bufferSize];
    return result.length;
  }
}

bool deletePassword(char *service, char *account) {
  @autoreleasepool{
    NSString *serviceString =
      [NSString stringWithCString:service encoding: NSUTF8StringEncoding];
    NSString *accountString =
      [NSString stringWithCString:account encoding: NSUTF8StringEncoding];

    OSStatus result = SecItemDelete(@{
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
