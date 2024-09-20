//
//  GroupsManager.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 01.03.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef GroupsManager_h
#define GroupsManager_h
#import "Group.h"

@interface GroupsManager : NSObject
+ (Group *) groupByIdentifier: (NSString *) identifier;
+ (NSArray<Group *> *) groupsList;

+ (BOOL) updateGroup:(Group *) group;
+ (BOOL) setGroup: (Group *) group enabled: (BOOL) enabled;
+ (BOOL) resetGroup: (Group *) group;
+ (BOOL) deleterGroup: (Group *) group;
+ (NSArray *) loadImportStatesForGroup: (Group *) group;
+ (BOOL) isZombie: (Group *) group;
+ (void) expireCheckStrategyFast:(BOOL) fastCheck;
+ (BOOL) isExpired: (Group *) group;
+ (BOOL) isActiveGroupExist;
+ (BOOL) isSuspendedGroupExist;
@end

#endif /* GroupsManager_h */
