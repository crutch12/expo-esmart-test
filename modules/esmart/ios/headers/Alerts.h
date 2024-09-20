//
//  Alerts.h
//  IsbcBeacon
//
//  Created by Daniil Dolbilov on 17.07.15.
//  Copyright (c) 2015 Daniil Dolbilov. All rights reserved.
//

#ifndef IsbcBeacon_Alerts_h
#define IsbcBeacon_Alerts_h

@import CoreFoundation;

@interface Alerts : NSObject

+ (void)showToast:(NSString*)msg :(int)durationSec;

+ (void)playSound;
+ (void) playTickSound;
+ (void)vibratePhone;

@end

#endif
