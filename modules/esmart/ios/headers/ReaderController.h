//
//  ReaderController.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 18.02.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef ReaderController_h
#define ReaderController_h
#import "ZoneInfo.h"
#import "ReaderProfile.h"

@interface ReaderController : NSObject
+ (void) loadDBConfigForReader: (ReaderProfile *) reader;
+ (void) updateConfigForReader: (ReaderProfile *) reader;
+ (void) sendUserIdToReader: (ReaderProfile *) reader withRepeatOnReSubscribe:(BOOL) repeatOnReSubscribe;
+ (void) sendSecuredBinary: (NSData *) binaryData toReader: (ReaderProfile *) reader withRandomData: (NSData *) randomData;
+ (void) requestForDisconnect: (ReaderProfile *) reader;
+ (void) requestReReadConfig: (ReaderProfile *) reader withRepeatOnReSubscribe:(BOOL) repeatOnReSubscribe;
+ (void) determineReaderVersion: (ReaderProfile *) reader;
@end

#endif /* ReaderController_h */
