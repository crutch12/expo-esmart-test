//
//  ZoneInfo.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 08.02.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef ZoneInfo_h
#define ZoneInfo_h

@interface ZoneInfo : NSObject
extern NSString * const BLETapZone;
extern NSString * const BLECommandZone;
extern int const BLEZoneMagnet;
@property NSString* zone;

@end

#endif /* ZoneInfo_h */
