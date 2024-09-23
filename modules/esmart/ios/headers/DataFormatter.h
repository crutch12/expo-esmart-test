//
//  Utils.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 03.02.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef Utils_h
#define Utils_h
@interface DataFormatter : NSObject

+ (NSData *) dataFromHexString: (NSString *) string;
+ (NSMutableString *)bytesToHexString: (const void *) bytes
						   withLength: (unsigned long)length
							andFormat:(BOOL) readableFormat;

@end;

#endif /* Utils_h */
