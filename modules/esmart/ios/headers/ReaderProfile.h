//
//  ReaderProfile.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 28.01.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef ReaderProfile_h
#define ReaderProfile_h
// @import CoreBluetooth;
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZoneInfo.h"
#import "ImportableDataItem.h"

@interface ReaderProfile : ImportableDataItem
	@property unsigned char rssi;
	@property (nonatomic) int TapArea;
	@property (nonatomic) int NotificationArea;
	@property ZoneInfo *CurrentZone;
	@property NSDate *lastSeen;
    @property (nonatomic, getter = getIdentifier, setter = setIdentifier:) NSString *identifier;
    @property (nonatomic, readonly) NSString *groupId;
	@property enum STATUS_LIST status;
	@property (nonatomic, readonly) NSString *readerVersion;
	@property (nonatomic) NSString *displayName;
	@property BOOL vibration;
	@property BOOL autoTalk;
	@property BOOL manualTalk;
	@property BOOL forceContinuousRSSI;
	@property NSDate *lastOpenTime;
	typedef enum {
		IC_handShakeRequired = 1 << 0,			// xxxxxxx1
		IC_autoOpenExist = 1 << 1,				// xxxxxx1x
		IC_manualOpenExist = 1 << 2,			// xxxxx1xx
		IC_forceContinuousRSSI = 1 << 3,		// xxxx1xxx
		IC_noUserId = 1 << 4,					// xxx1xxxx
		IC_phoneReadyToConfig = 1 << 5			// xx1xxxxx
	} ConfigBits;

- (BOOL) identifierDetermined;
- (void) setConfigId: (NSData *) configId;
- (NSData *) getConfigId;
@end

#endif /* ReaderProfile_h */
