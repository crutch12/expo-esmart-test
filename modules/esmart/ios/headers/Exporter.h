//
//  Exporter.h
//  EsmartVirtualCard
//
//  Created by Alexandr Petrov on 06.09.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef Exporter_h
#define Exporter_h
#import "Group.h"

@interface Exporter : NSObject
+ (BOOL) exportDataWithShare;
+ (BOOL) exportDataToDocuments;
+ (NSData *) requestConfigForGroup: (Group *) group withSecureCode: (NSString *) secureCode;
@end

#endif /* Exporter_h */
