//
//  ReaderStatuses.h
//  isbcKeyCard
//
//  Created by Petrov Alexander on 26.02.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef ReaderStatuses_h
#define ReaderStatuses_h

@interface ReaderStatuses:NSObject
enum STATUS_LIST {
	ROAMING			= 0,
	WAITING			= 1,
	ARMED			= 2,
	OPENING			= 3,
	COMWAIT			= 4,// Command wait ?
	GRPDETERMINE	= 5,
	WAITRSA			= 6,
};

+ (NSString *) toString:(enum STATUS_LIST) status;

@end
#endif /* ReaderStatuses_h */
