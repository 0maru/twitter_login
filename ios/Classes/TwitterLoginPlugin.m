#import "TwitterLoginPlugin.h"
#if __has_include(<twitter_login/twitter_login-Swift.h>)
#import <twitter_login/twitter_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "twitter_login-Swift.h"
#endif

@implementation TwitterLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTwitterLoginPlugin registerWithRegistrar:registrar];
}
@end
