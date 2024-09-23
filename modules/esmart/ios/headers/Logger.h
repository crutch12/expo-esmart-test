//
//  Logger.h
//  EsmartVirtualCard
//
//  Created by Alexandr Petrov on 27.05.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef Logger_h
#define Logger_h

@interface Logger : NSObject
+ (void) dumpLogs;
+ (void) purgeLogs;
+ (void) pauseLogs;
+ (BOOL) logsPaused;

+ (NSString *) getCount;
+ (void) realTimeLog: (BOOL) enabled;
@end

#endif /* Logger_h */
