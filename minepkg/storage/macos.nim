{.passL: "-framework Security".}

import os
import options

{.emit: """

#import <Foundation/Foundation.h>;
#import <Security/Security.h>;

bool storeInKeychain(char *service, char *account, char *value, uint size,
                     bool passwordless) {
  @autoreleasepool{
    NSString *serviceString =
      [NSString stringWithCString:service encoding: NSUTF8StringEncoding];
    NSString *accountString =
      [NSString stringWithCString:account encoding: NSUTF8StringEncoding];
    NSData *valueData =
      [NSData dataWithBytes:value length:size];

    NSArray* trustedlist;
    if (passwordless) {
      trustedlist = nil; // default, includes the current application
    } else {
      trustedlist = @[];
    }

    SecAccessRef access;
    SecAccessCreate(
      (__bridge CFStringRef)@"Mine̼ main secret",
      (__bridge CFArrayRef)trustedlist,
      &access
    );

    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)@{
      (id)kSecClass: (id)kSecClassGenericPassword,
      (id)kSecAttrService: serviceString,
      (id)kSecAttrAccount: accountString,
      (id)kSecAttrAccess: (__bridge id)access,
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

int retrieveFromKeychain(char *service, char *account, char *buffer,
                         uint bufferSize) {
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

bool deleteFromKeychain(char *service, char *account) {
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

proc storeInKeychain(service, account, value: cstring, size: uint,
                      passwordless: bool = false): bool {.importc, nodecl.}
proc retrieveFromKeychain(service, account: cstring, buffer: ptr char,
                          bufferSize: uint): int {.importc, nodecl.}
proc deleteFromKeychain(service, account: cstring): bool {.importc, nodecl.}

proc getAppName: string =
  getAppFilename().extractFilename()

proc retrieveString*(name: string): Option[string] =
  var buffer: array[4096, char]
  let size = retrieveFromKeychain(getAppName(), name, addr buffer[0],
                                  buffer.len.uint)
  if size == -1:
    result = none[string]()
  else:
    result = some(cast[string](buffer[0..<size]))

proc storeString*(name: string, value: string) =
  assert storeInKeychain(getAppName(), name, value, value.len.uint,
                         passwordless = defined(test))

proc deleteString*(name: string) =
  discard deleteFromKeychain(getAppName(), name)
