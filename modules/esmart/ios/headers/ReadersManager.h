//
//  ReadersManager.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 28.01.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef ReadersManager_h
#define ReadersManager_h
#import "ReaderProfile.h"

@interface ReadersManager : NSObject

@property NSMutableArray *readersPool;

+ (ReadersManager *) getInstance;
- (ReaderProfile *) getReaderProfileById: (NSString *) identifier;
- (void) deleteReadersByGroupId: (NSString *) groupId;
- (void) deleteReader: (NSString *) identifier;
+(NSArray<ReaderProfile *> *) readersListForGroup:(NSString *) groupId;
@end

#endif /* ReadersManager_h */
