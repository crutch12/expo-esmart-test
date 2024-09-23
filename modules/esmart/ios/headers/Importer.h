//
//  Importer.h
//  EsmartVirtualCard
//
//  Created by Alexandr Petrov on 01.09.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef Importer_h
#define Importer_h

@interface Importer : NSObject;
+ (NSDictionary *) importFile: (NSURL *) dataToImport batchOperation: (BOOL) batch;
+ (void) importDataFromFiles: (NSArray *) filesToImport;
+ (void) importFile: (NSURL *) fileToImport forGroupId: (NSString *) groupId;
@end

#endif /* Importer_h */
