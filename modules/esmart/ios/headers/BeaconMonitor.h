//
//  BeaconMonitor.h
//  EsmartVirtualCard
//
//  Created by Alexandr Petrov on 25.08.16.
//  Copyright © 2016 ISBC. All rights reserved.
//

#ifndef BeaconMonitor_h
#define BeaconMonitor_h
#import <CoreLocation/CoreLocation.h>

@interface BeaconMonitor : NSObject
+ (void) prepareForBeaconMonitoring: (CLLocationManager *) manager;
+ (void) startBeaconMonitoring;
+ (void) beaconMonitoringStarted:(CLRegion *)region;
+ (void) stopBeaconMonitoring;
+ (void) enterRegion:(CLRegion *)region;
+ (void) exitRegion:(CLRegion *)region;
#if WATCH_OS == 1
#else
+ (void) determineState:(CLRegionState) state forRegion:(CLRegion *)region;
#endif
@end

#endif /* BeaconMonitor_h */
