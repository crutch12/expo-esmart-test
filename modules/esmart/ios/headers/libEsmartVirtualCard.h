//
//  libKeyCard.h
//  libKeyCard
//
//  Created by Petrov Alexander on 30.03.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeviceVersion : NSObject
@property NSString *rawPlatform;
@property NSString *device;
@property NSNumber *hiDeviceNumber;
@property NSNumber *loDeviceNumber;
- (BOOL) isOldIPod;
- (BOOL) isOldIPhone;
@end

@interface libKeyCard : NSObject
@property BOOL closedDueToMaintenance;
@property DeviceVersion *deviceVersion;

+ (libKeyCard *) getInstance __attribute ((deprecated("use + (void) hostAppDidFinishLaunchingWithOptions: (NSDictionary *)launchOptions instead.")));
- (BOOL) initLibrary __attribute ((deprecated("use + (void) hostAppDidFinishLaunchingWithOptions: (NSDictionary *)launchOptions instead.")));
+ (void) dropInstance __attribute ((deprecated("use + (void) hostAppDidWillTerminate: (UIApplication *)application instead.")));

+ (NSString *) apiVersion;
#if WATCH_OS == 1
#else
+ (void) hostAppDidFinishLaunchingWithOptions: (NSDictionary *)launchOptions;
+ (void) hostAppDidEnterBackground: (UIApplication *)application;
+ (void) hostAppDidBecomeActive: (UIApplication *)application;
+ (void) hostAppDidWillTerminate: (UIApplication *)application;
#endif
+ (DeviceVersion *) determineDevice;
enum CARD_MODE {
	MODE_UNDEFINED		= 0,
	MODE_TOUCH_AS_CARD	= 1,
	MODE_HANDS_FREE		= 2,
};

@end
