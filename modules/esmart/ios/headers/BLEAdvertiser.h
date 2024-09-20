//
//  BLEAdvertiser.h
//  IsbcBeacon
//
//  Created by Petrov Alexander on 16.12.15.
//  Copyright © 2015 Daniil Dolbilov. All rights reserved.
//

@import CoreBluetooth;
#import <UIKit/UIKit.h>

@interface BLEAdvertiser : NSObject <CBPeripheralManagerDelegate>
extern float const IN_VIEW_INTERVAL;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
+ (BOOL) isAdvertising;
+ (BOOL) isServicesAdvertised;
+ (void) startAdvertising;
+ (void) stopAdvertising;
+ (void) enableSendUserId;
+ (void) disableSendUserId;
+ (void) backgroundProcessingEnabled: (BOOL) enabled;
+ (BOOL) isBackgroundProcessingEnabled;
+ (CBManagerState) currentBTMState;
+ (NSString *) serviceUid;
+ (void) relauchControlledExternally: (BOOL) externally;
@end
