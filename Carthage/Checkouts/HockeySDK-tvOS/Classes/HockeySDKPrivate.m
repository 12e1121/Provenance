#import "HockeySDK.h"
#import "HockeySDKPrivate.h"
#include <CommonCrypto/CommonDigest.h>

NSString *const kBITCrashErrorDomain = @"BITCrashReporterErrorDomain";
NSString *const kBITUpdateErrorDomain = @"BITUpdaterErrorDomain";
NSString *const kBITFeedbackErrorDomain = @"BITFeedbackErrorDomain";
NSString *const kBITHockeyErrorDomain = @"BITHockeyErrorDomain";
NSString *const kBITAuthenticatorErrorDomain = @"BITAuthenticatorErrorDomain";

// Load the framework bundle.
NSBundle *BITHockeyBundle(void) {
  static NSBundle *bundle = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    NSString* mainBundlePath = [[NSBundle bundleForClass:[BITHockeyManager class]] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:BITHOCKEYSDK_BUNDLE];
    bundle = [NSBundle bundleWithPath:frameworkBundlePath];
  });
  return bundle;
}

NSString *BITHockeyLocalizedString(NSString *stringToken) {
  if (!stringToken) return @"";
  
  NSString *appSpecificLocalizationString = NSLocalizedString(stringToken, @"");
  if (appSpecificLocalizationString && ![stringToken isEqualToString:appSpecificLocalizationString]) {
    return appSpecificLocalizationString;
  } else if (BITHockeyBundle()) {
    NSString *bundleSpecificLocalizationString = NSLocalizedStringFromTableInBundle(stringToken, @"HockeySDK", BITHockeyBundle(), @"");
    if (bundleSpecificLocalizationString)
      return bundleSpecificLocalizationString;
    return stringToken;
  } else {
    return stringToken;
  }
}

NSString *BITHockeyMD5(NSString *str) {
  NSData *utf8Bytes = [str dataUsingEncoding:NSUTF8StringEncoding];
  unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
  CC_MD5( utf8Bytes.bytes, (CC_LONG)utf8Bytes.length, result );
  return [NSString
          stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
          result[0], result[1],
          result[2], result[3],
          result[4], result[5],
          result[6], result[7],
          result[8], result[9],
          result[10], result[11],
          result[12], result[13],
          result[14], result[15]
          ];
}
