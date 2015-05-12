/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate()

@property (nonatomic, strong) ViewController *viewController;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSURL *initialJSBundleURL;
  NSString *initialModuleName;


  // Example:
  // NSString *suppliedAppId = @"qAFzcA";
  // NSString *suppliedModuleName = @"ParallaxExample";

   NSString *suppliedAppId = [[NSUserDefaults standardUserDefaults] stringForKey:@"appId"];
   NSString *suppliedModuleName = [[NSUserDefaults standardUserDefaults] stringForKey:@"moduleName"];

  if (suppliedAppId) {
    initialJSBundleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", @"http://packager.rnplay.org/", suppliedAppId, @".bundle"]];
    initialModuleName = suppliedModuleName;
  } else {
    initialJSBundleURL = [NSURL URLWithString:[[[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"] absoluteString]];
    initialModuleName = @"RNPlayNative";
  }

  self.viewController = [[ViewController alloc] initWithLaunchOptions:launchOptions];
  [self.viewController reloadWithJSBundleURL:initialJSBundleURL moduleNamed:initialModuleName];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = self.viewController;
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];

  return YES;
}

@end

#import "RCTBridgeModule.h"

@interface AppReloader : NSObject <RCTBridgeModule>
@end

@implementation AppReloader

RCT_EXPORT_MODULE()

-(dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

/**
 *  var AppReloader = require('NativeModules').AppReloader;
 *  AppReloader.reloadAppWithURLString('https://example.com/index.ios.bundle', 'App')
 */
RCT_EXPORT_METHOD(reloadAppWithURLString:(NSString *)URLString moduleNamed:(NSString *)moduleName) {
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

  NSURL *JSBundleURL = [NSURL URLWithString:URLString];
  [delegate.viewController reloadWithJSBundleURL:JSBundleURL moduleNamed:moduleName];
}

@end
