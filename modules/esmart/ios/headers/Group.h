//
//  Group.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 29.02.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef Group_h
#define Group_h
#import "ImportableDataItem.h"


@interface Group : ImportableDataItem
@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *groupName;
@property (nonatomic) NSNumber *keyId;
@property (nonatomic) NSData *userId;
@property (nonatomic) int defaultTapArea;
@property (nonatomic) int defaultNotificationArea;
@property (nonatomic) NSString *adminEMail;
@property (nonatomic) NSString *adminPhone;
@property (nonatomic) NSString *helpText;
@property (nonatomic) NSString *helpTextInt;
@property (nonatomic) BOOL enabled;
@property (nonatomic) NSString *exchangeVersion;
@property (readonly) int expire;
@property (readonly) bool expired;
@property (readonly) NSString *activationId;
@property NSData *requestData;
- (NSDate *) verifyDone;
@end

#endif /* Group_h */
