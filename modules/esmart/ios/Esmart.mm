//
//  Esmart.m
//  Esmart
//
//  Created by Денис Либит on 04.03.2019.
//

#import "Esmart.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonCryptor.h>

#import "Alerts.h"
#import "BeaconMonitor.h"
#import "BLEAdvertiser.h"
#import "DataFormatter.h"
#import "Exporter.h"
#import "Group.h"
#import "GroupsManager.h"
#import "ImportableDataItem.h"
#import "Importer.h"
#import "libEsmartVirtualCard.h"
#import "Logger.h"
#import "ReaderController.h"
#import "ReaderProfile.h"
#import "ReadersManager.h"
#import "ReaderStatuses.h"
#import "ZoneInfo.h"

@implementation RCTAppDelegate(Launch)
- (RCTBridge *)createBridgeWithDelegate:(id<RCTBridgeDelegate>)delegate launchOptions:(NSDictionary*)launchOptions {
    RCTBridge *returnValue = [super createBridgeWithDelegate:delegate launchOptions:launchOptions];

    // 3.3.7
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"VirtualCardEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LogsEnabled"];
    [[NSUserDefaults standardUserDefaults] setInteger:MODE_HANDS_FREE forKey:@"CardMode"];

    [Logger purgeLogs];
    [Logger realTimeLog:YES];

    if ([Logger logsPaused]) {
        [Logger pauseLogs]; // метод вкл/выкл логов один и тот же
    }

    [libKeyCard hostAppDidFinishLaunchingWithOptions:launchOptions];

    [BLEAdvertiser backgroundProcessingEnabled:YES];
    [BLEAdvertiser enableSendUserId];

    return returnValue;
}
@end



@interface Esmart (prvate)

// -(BOOL) checkArguments:(NSArray*) args withTypes:(NSArray<Class>*) types;

- (NSDictionary*) mapZoneInfo:(ZoneInfo*) zoneInfo;
@end

@interface Esmart () <CLLocationManagerDelegate>

typedef NSDictionary *(^NotificationHandler)(NSNotification *);

// @property (nonatomic, strong) CLLocationManager *locationManager;
// @property (nonatomic, strong) NSString *beaconMonitorPrepareCallbackID;
// @property (nonatomic, strong) NSString *notificationsCallbackID;
// @property (nonatomic, strong) NSDictionary<NSString *, NotificationHandler> *reactions;

@end



@implementation Esmart
RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_EXPORT_METHOD(multiply:(double)a
                  b:(double)b
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    NSNumber *result = @(a * b);

    resolve(result);
}

#pragma mark - Жизненный цикл

// - (void)pluginInitialize
// {
//     [super pluginInitialize];
//
//     // пробрасываем состояние приложения в библиотеку
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)    name:UIApplicationDidBecomeActiveNotification    object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:)      name:UIApplicationWillTerminateNotification      object:nil];
// }

// - (void)dealloc
// {
//     [[NSNotificationCenter defaultCenter] removeObserver:self];
// }
//
// - (void)applicationDidEnterBackground:(UIApplication *)application
// {
//     [libKeyCard hostAppDidEnterBackground:application];
// }
//
// - (void)applicationDidBecomeActive:(UIApplication *)application
// {
//     [libKeyCard hostAppDidBecomeActive:application];
// }
//
// - (void)applicationWillTerminate:(NSNotification *)notification
// {
//     [libKeyCard hostAppDidWillTerminate:[notification object]];
// }

// #pragma mark - Настройки
//
// - (void)globalPropertyGetVirtualCardEnabled:(CDVInvokedUrlCommand *)command
// {
//     BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"VirtualCardEnabled"];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:value];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)globalPropertySetVirtualCardEnabled:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *argument = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (argument) {
//         [[NSUserDefaults standardUserDefaults] setBool:[argument boolValue] forKey:@"VirtualCardEnabled"];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)globalPropertyGetPersistedUserIdStore:(CDVInvokedUrlCommand *)command
// {
//     BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"PersistedUserIdStore"];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:value];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)globalPropertySetPersistedUserIdStore:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *argument = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (argument) {
//         [[NSUserDefaults standardUserDefaults] setBool:[argument boolValue] forKey:@"PersistedUserIdStore"];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)globalPropertyGetUseExternalUserIdGenerator:(CDVInvokedUrlCommand *)command
// {
//     BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"UseExternalUserIdGenerator"];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:value];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)globalPropertySetUseExternalUserIdGenerator:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *argument = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (argument) {
//         [[NSUserDefaults standardUserDefaults] setBool:[argument boolValue] forKey:@"UseExternalUserIdGenerator"];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)globalPropertyGetOldDeviceOverride:(CDVInvokedUrlCommand *)command
// {
//     BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"OldDeviceOverride"];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:value];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)globalPropertySetOldDeviceOverride:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *argument = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (argument) {
//         [[NSUserDefaults standardUserDefaults] setBool:[argument boolValue] forKey:@"OldDeviceOverride"];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)globalPropertyGetTapAreaComfortSelector:(CDVInvokedUrlCommand *)command
// {
//     BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"TapAreaComfortSelector"];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:value];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)globalPropertySetTapAreaComfortSelector:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *argument = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (argument) {
//         [[NSUserDefaults standardUserDefaults] setBool:[argument boolValue] forKey:@"TapAreaComfortSelector"];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)globalPropertyGetOnlyKnownGroupsAllowed:(CDVInvokedUrlCommand *)command
// {
//     BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"OnlyKnownGroupsAllowed"];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:value];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)globalPropertySetOnlyKnownGroupsAllowed:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *argument = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (argument) {
//         [[NSUserDefaults standardUserDefaults] setBool:[argument boolValue] forKey:@"OnlyKnownGroupsAllowed"];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// #pragma mark - libKeyCard
//
// - (void)libKeyCardGetAPIVersion:(CDVInvokedUrlCommand *)command
// {
//     NSString *value = [libKeyCard apiVersion];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// #pragma mark - ReaderController
//
// - (void)readerControllerLoadDBConfigForReader:(CDVInvokedUrlCommand *)command
// {
//     NSString *readerID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     ReaderProfile *reader = [[ReadersManager getInstance] getReaderProfileById:readerID];
//
//     if (reader) {
//         [ReaderController loadDBConfigForReader:reader];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)readerControllerUpdateConfigForReader:(CDVInvokedUrlCommand *)command
// {
//     NSString *readerID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     ReaderProfile *reader = [[ReadersManager getInstance] getReaderProfileById:readerID];
//
//     if (reader) {
//         [ReaderController updateConfigForReader:reader];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)readerControllerSendUserIdToReader:(CDVInvokedUrlCommand *)command
// {
//     NSString *readerID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     NSNumber *repeatOnReSubscribe = [command argumentAtIndex:1 withDefault:@NO andClass:[NSNumber class]];
//     ReaderProfile *reader = [[ReadersManager getInstance] getReaderProfileById:readerID];
//
//     if (reader) {
//         [ReaderController sendUserIdToReader:reader withRepeatOnReSubscribe:[repeatOnReSubscribe boolValue]];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)readerControllerRequestReReadConfig:(CDVInvokedUrlCommand *)command
// {
//     NSString *readerID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     NSNumber *repeatOnReSubscribe = [command argumentAtIndex:1 withDefault:@NO andClass:[NSNumber class]];
//     ReaderProfile *reader = [[ReadersManager getInstance] getReaderProfileById:readerID];
//
//     if (reader) {
//         [ReaderController requestReReadConfig:reader withRepeatOnReSubscribe:[repeatOnReSubscribe boolValue]];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// #pragma mark - ReadersManager
//
// - (void)readersManagerGetReadersPool:(CDVInvokedUrlCommand *)command
// {
//     NSArray *readers = [[ReadersManager getInstance] readersPool];
//     NSMutableArray *readerIDs = [NSMutableArray arrayWithCapacity:readers.count];
//
//     for (ReaderProfile *reader in readers) {
//         [readerIDs addObject:reader.identifier];
//     }
//
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[readerIDs copy]];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)readersManagerDeleteReadersByGroupID:(CDVInvokedUrlCommand *)command;
// {
//     NSString *groupID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//
//     if (groupID) {
//         [[ReadersManager getInstance] deleteReadersByGroupId:groupID];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)readersManagerDeleteReader:(CDVInvokedUrlCommand *)command;
// {
//     NSString *readerID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//
//     if (readerID) {
//         [[ReadersManager getInstance] deleteReader:readerID];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)readersManagerGetReadersListForGroup:(CDVInvokedUrlCommand *)command;
// {
//     NSString *groupID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//
//     if (groupID) {
//         NSArray *readers = [ReadersManager readersListForGroup:groupID];
//         NSMutableArray *readerIDs = [NSMutableArray arrayWithCapacity:readers.count];
//
//         for (ReaderProfile *reader in readers) {
//             [readerIDs addObject:reader.identifier];
//         }
//
//         CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[readerIDs copy]];
//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// #pragma mark - GroupsManager
//
// - (void)groupsManagerGetGroupsList:(CDVInvokedUrlCommand *)command
// {
//     NSArray *groups = [GroupsManager groupsList];
//     NSMutableArray *groupIDs = [NSMutableArray arrayWithCapacity:groups.count];
//
//     for (Group *group in groups) {
//         [groupIDs addObject:group.groupId];
//     }
//
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[groupIDs copy]];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)groupsManagerUpdateGroup:(CDVInvokedUrlCommand *)command
// {
//     NSString *groupID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     Group *group = [GroupsManager groupByIdentifier:groupID];
//
//     if (group) {
//         group.groupName = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
//         group.keyId     = [command argumentAtIndex:2 withDefault:nil andClass:[NSNumber class]];
//         group.userId    = [command argumentAtIndex:3 withDefault:nil andClass:[NSData class]];
//
//         [GroupsManager updateGroup:group];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)groupsManagerDeleteGroup:(CDVInvokedUrlCommand *)command
// {
//     NSString *groupID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     Group *group = [GroupsManager groupByIdentifier:groupID];
//
//     if (group && [GroupsManager deleterGroup:group]) {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)groupsManagerSetExpireCheckStrategyFast:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *isFast = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (isFast) {
//         [GroupsManager expireCheckStrategyFast:[isFast boolValue]];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)groupsManagerGetIsExpired:(CDVInvokedUrlCommand *)command
// {
//     NSString *groupID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     Group *group = [GroupsManager groupByIdentifier:groupID];
//
//     if (group) {
//         BOOL isExpired = [GroupsManager isExpired:group];
//         CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isExpired];
//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)groupsManagerSetGroupEnabled:(CDVInvokedUrlCommand *)command
// {
//     NSString *groupID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     NSNumber *isEnabled = [command argumentAtIndex:1 withDefault:nil andClass:[NSNumber class]];
//     Group *group = [GroupsManager groupByIdentifier:groupID];
//
//     if (group && isEnabled && [GroupsManager setGroup:group enabled:[isEnabled boolValue]]) {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)groupsManagerIsActiveGroupExist:(CDVInvokedUrlCommand *)command
// {
//     BOOL isActiveGroupExist = [GroupsManager isActiveGroupExist];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isActiveGroupExist];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)groupsManagerIsSuspendedGroupExist:(CDVInvokedUrlCommand *)command
// {
//     BOOL isSuspendedGroupExist = [GroupsManager isSuspendedGroupExist];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isSuspendedGroupExist];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// #pragma mark - BLEAdvertiser
//
// - (void)bleAdvertiserIsAdvertising:(CDVInvokedUrlCommand *)command
// {
//     BOOL isAdvertising = [BLEAdvertiser isAdvertising];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isAdvertising];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)bleAdvertiserStartAdvertising:(CDVInvokedUrlCommand *)command
// {
//     [BLEAdvertiser startAdvertising];
//     [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
// }
//
// - (void)bleAdvertiserStopAdvertising:(CDVInvokedUrlCommand *)command
// {
//     [BLEAdvertiser stopAdvertising];
//     [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
// }
//
// - (void)bleAdvertiserEnableSendUserId:(CDVInvokedUrlCommand *)command
// {
//     [BLEAdvertiser enableSendUserId];
//     [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
// }
//
// - (void)bleAdvertiserDisableSendUserId:(CDVInvokedUrlCommand *)command
// {
//     [BLEAdvertiser disableSendUserId];
//     [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
// }
//
// - (void)bleAdvertiserGetBackgroundProcessingEnabled:(CDVInvokedUrlCommand *)command
// {
//     BOOL isBackgroundProcessingEnabled = [BLEAdvertiser isBackgroundProcessingEnabled];
//     CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isBackgroundProcessingEnabled];
//     [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
// }
//
// - (void)bleAdvertiserSetBackgroundProcessingEnabled:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *isEnabled = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (isEnabled) {
//         [BLEAdvertiser backgroundProcessingEnabled:[isEnabled boolValue]];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)bleAdvertiserRelauchControlledExternally:(CDVInvokedUrlCommand *)command
// {
//     NSNumber *isExternally = [command argumentAtIndex:0 withDefault:nil andClass:[NSNumber class]];
//
//     if (isExternally) {
//         [BLEAdvertiser relauchControlledExternally:[isExternally boolValue]];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// #pragma mark - BeaconMonitor
//
// - (void)beaconMonitorPrepare:(CDVInvokedUrlCommand *)command
// {
//     if (self.locationManager != nil) {
//         return;
//     }
//
//     self.beaconMonitorPrepareCallbackID = command.callbackId;
//
//     self.locationManager = [[CLLocationManager alloc] init];
//     self.locationManager.delegate = self;
//     self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//     self.locationManager.allowsBackgroundLocationUpdates = YES;
//
//     [self handleAuthorizationStatus:[CLLocationManager authorizationStatus]];
// }
//
// - (void)beaconMonitorStart:(CDVInvokedUrlCommand *)command
// {
//     [self.locationManager startUpdatingLocation];
//     [BeaconMonitor startBeaconMonitoring];
// }
//
// - (void)beaconMonitorStop:(CDVInvokedUrlCommand *)command
// {
//     [self.locationManager stopUpdatingLocation];
//     [BeaconMonitor stopBeaconMonitoring];
// }
//
// - (void)beaconMonitorAddBeaconRegionMonitoring:(CDVInvokedUrlCommand *)command
// {
//     NSString *proximityUUIDString = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     NSString *identifier          = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
//     NSNumber *majorNumber         = [command argumentAtIndex:2 withDefault:nil andClass:[NSNumber class]];
//     NSNumber *minorNumber         = [command argumentAtIndex:3 withDefault:nil andClass:[NSNumber class]];
//
//     if (!proximityUUIDString || !identifier) {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//         return;
//     }
//
//     NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:proximityUUIDString];
//
//     if (!proximityUUID) {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//         return;
//     }
//
//     CLBeaconRegion *region;
//
//     if (majorNumber) {
//         if (minorNumber) {
//             region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID major:[majorNumber unsignedShortValue] minor:[minorNumber unsignedShortValue] identifier:identifier];
//         } else {
//             region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID major:[majorNumber unsignedShortValue] identifier:identifier];
//         }
//     } else {
//         region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
//     }
//
//     [self.locationManager startMonitoringForRegion:region];
//     [BeaconMonitor beaconMonitoringStarted:region];
//     [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
// }
//
// #pragma mark - Делегат CLLocationManager
//
// - (void)handleAuthorizationStatus:(CLAuthorizationStatus)status
// {
//     switch (status) {
//         case kCLAuthorizationStatusNotDetermined:
//             [self.locationManager requestWhenInUseAuthorization];
//             return;
//
//         case kCLAuthorizationStatusAuthorizedWhenInUse:
//             [self.locationManager requestAlwaysAuthorization];
//             return;
//
//         case kCLAuthorizationStatusRestricted:
//         case kCLAuthorizationStatusDenied:
//             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:self.beaconMonitorPrepareCallbackID];
//             return;
//
//         case kCLAuthorizationStatusAuthorizedAlways:
//             [BeaconMonitor prepareForBeaconMonitoring:self.locationManager];
//             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:self.beaconMonitorPrepareCallbackID];
//             self.beaconMonitorPrepareCallbackID = nil;
//             break;
//
//         default:
//             break;
//     }
// }
//
// - (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
// {
//     [self handleAuthorizationStatus:status];
// }
//
// - (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
// {
//     [BeaconMonitor enterRegion:region];
// }
//
// - (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
// {
//     [BeaconMonitor exitRegion:region];
// }
//
// #pragma mark - Importer
//
// - (BOOL)internalSetKey:(NSData *)key
// {
//     if (!key || key.length != 16) {
//         return NO;
//     }
//
//     // параметры запроса
//     NSMutableDictionary *query = [NSMutableDictionary dictionary];
//
//     query[(__bridge id)kSecClass]              = (__bridge id)kSecClassGenericPassword;
//     query[(__bridge id)kSecAttrSynchronizable] = (__bridge id)kSecAttrSynchronizableAny;
//     query[(__bridge id)kSecAttrService]        = @"ISBCKeyCard";
//     query[(__bridge id)kSecAttrAccount]        = @"K_AES";
//
//     // убьём старый ключ, если есть
//     SecItemDelete((__bridge CFDictionaryRef)query);
//
//     // сохраним новый ключ
//     query[(__bridge id)kSecValueData]          = key;
//     query[(__bridge id)kSecAttrAccessible]     = (__bridge id)kSecAttrAccessibleAlways;
//
//     return SecItemAdd((__bridge CFMutableDictionaryRef)query, NULL) == errSecSuccess;
// }
//
// - (NSData *)internalGetKey
// {
//     // параметры запроса
//     NSMutableDictionary *query = [NSMutableDictionary dictionary];
//
//     query[(__bridge id)kSecClass]              = (__bridge id)kSecClassGenericPassword;
//     query[(__bridge id)kSecAttrSynchronizable] = (__bridge id)kSecAttrSynchronizableAny;
//     query[(__bridge id)kSecAttrService]        = @"ISBCKeyCard";
//     query[(__bridge id)kSecAttrAccount]        = @"K_AES";
//     query[(__bridge id)kSecReturnData]         = @YES;
//
//     // попробуем получить ключ
//     CFTypeRef resultRef;
//
//     if (SecItemCopyMatching((__bridge CFMutableDictionaryRef)query, &resultRef) != errSecSuccess) {
//         return nil;
//     }
//
//     NSData *key = (__bridge id)resultRef;
//
//     return key;
// }
//
// - (void)importerSetAESKey:(CDVInvokedUrlCommand *)command
// {
//     NSData *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSData class]];
//
//     if ([self internalSetKey:key]) {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)importerGenerateAndSetAESKey:(CDVInvokedUrlCommand *)command
// {
//     // сгенерируем новый ключ
//     uuid_t uuid;
//     [[NSUUID UUID] getUUIDBytes:uuid];
//     NSData *key = [NSData dataWithBytes:uuid length:16];
//
//     // сохраним
//     if ([self internalSetKey:key]) {
//         CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:key];
//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)importerImportDataFromFiles:(CDVInvokedUrlCommand *)command
// {
//     NSArray *strings = [command argumentAtIndex:0 withDefault:nil andClass:[NSArray class]];
//     NSMutableArray<NSURL *> *urls = [NSMutableArray arrayWithCapacity:strings.count];
//
//     for (NSString *string in strings) {
//         NSURL *url = [NSURL fileURLWithPath:string];
//
//         if (url) {
//             [urls addObject:url];
//         } else {
//             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//             return;
//         }
//     }
//
//     [Importer importDataFromFiles:urls];
//     [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
// }
//
// - (void)importerImportDataFromFile:(CDVInvokedUrlCommand *)command
// {
//     NSString *string = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     NSURL *url = [NSURL fileURLWithPath:string];
//
//     if (url) {
//         [Importer importFile:url batchOperation:NO];
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//         return;
//     }
// }
//
// #pragma mark - ReaderProfile
//
// - (void)readerProfileGetInfo:(CDVInvokedUrlCommand *)command
// {
//     NSString *readerID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     ReaderProfile *reader = [[ReadersManager getInstance] getReaderProfileById:readerID];
//
//     if (reader) {
//         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//
//         dict[@"rssi"]                = @(reader.rssi);
//         dict[@"TapArea"]             = @(reader.TapArea);
//         dict[@"NotificationArea"]    = @(reader.NotificationArea);
//         dict[@"CurrentZone"]         = reader.CurrentZone.zone;
//         dict[@"lastSeen"]            = @([reader.lastSeen timeIntervalSince1970]);
//         dict[@"identifier"]          = reader.identifier;
//         dict[@"groupId"]             = reader.groupId;
//         dict[@"status"]              = @(reader.status);
//         dict[@"readerVersion"]       = reader.readerVersion;
//         dict[@"displayName"]         = reader.displayName;
//         dict[@"vibration"]           = @(reader.vibration);
//         dict[@"autoTalk"]            = @(reader.autoTalk);
//         dict[@"manualTalk"]          = @(reader.manualTalk);
//         dict[@"forceContinuousRSSI"] = @(reader.forceContinuousRSSI);
//         dict[@"lastOpenTime"]        = @([reader.lastOpenTime timeIntervalSince1970]);
//
//         CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// - (void)readerProfileIsIdentifierDetermined:(CDVInvokedUrlCommand *)command
// {
//     NSString *readerID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     ReaderProfile *reader = [[ReadersManager getInstance] getReaderProfileById:readerID];
//
//     if (reader) {
//         BOOL isIdentifierDetermined = [reader identifierDetermined];
//         CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isIdentifierDetermined];
//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// #pragma mark - Group
//
// - (void)groupGetInfo:(CDVInvokedUrlCommand *)command
// {
//     NSString *groupID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
//     Group *group = [GroupsManager groupByIdentifier:groupID];
//
//     if (group) {
//         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//
//         dict[@"groupId"]                 = group.groupId;
//         dict[@"groupName"]               = group.groupName;
//         dict[@"keyId"]                   = group.keyId;
//         dict[@"userId"]                  = [group.userId base64EncodedStringWithOptions:0];
//         dict[@"defaultTapArea"]          = @(group.defaultTapArea);
//         dict[@"defaultNotificationArea"] = @(group.defaultNotificationArea);
//         dict[@"adminEMail"]              = group.adminEMail;
//         dict[@"adminPhone"]              = group.adminPhone;
//         dict[@"helpText"]                = group.helpText;
//         dict[@"helpTextInt"]             = group.helpTextInt;
//         dict[@"enabled"]                 = @(group.enabled);
//         dict[@"exchangeVersion"]         = group.exchangeVersion;
//         dict[@"expire"]                  = @(group.expire);
//         dict[@"expired"]                 = @(group.expired);
//         dict[@"activationId"]            = group.activationId;
//         dict[@"requestData"]             = [group.requestData base64EncodedStringWithOptions:0];
//
//         CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
//         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//     } else {
//         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//     }
// }
//
// -(void) groupVerifyDone:(CDVInvokedUrlCommand*)command {
//
//     BOOL isCorrectArgs = [self checkArguments:command.arguments withTypes:@[ [NSString class]]];
//     if (isCorrectArgs == NO) {
//         [self sendErrorWithCallbackId:command.callbackId];
//         return;
//     }
//     NSString* groupId = command.arguments.firstObject;
//     Group* group = [GroupsManager groupByIdentifier:groupId];
//     NSDate* verifyDone = [group verifyDone];
//     if (verifyDone == nil) {
//         [self sendErrorWithCallbackId:command.callbackId];
//         return;
//     }
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:verifyDone.timeIntervalSince1970];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }
//
// #pragma mark - DataFormatter
//
// /// Переводит ASCII-строку с шестнадцатеричными цифрами в последовательность байтового представления
// -(void) dataFromHexString :(CDVInvokedUrlCommand*)command {
//
//     NSObject* inputValue = [command.arguments firstObject];
//     if (inputValue != nil && [inputValue isKindOfClass:[NSString class]]) {
//         NSString* string = (NSString*)inputValue;
//         NSData* data = [DataFormatter dataFromHexString:string];
//         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:data];
//         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//     } else {
//         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//     }
// }
//
// /// преобразует байты данных в ASCII-строку.
// -(void) bytesToHexString:(CDVInvokedUrlCommand*)command{
//
//     BOOL isCorrectArgs = [self checkArguments:command.arguments withTypes:@[ [NSData class], [NSNumber class]]];
//     if (isCorrectArgs == NO) {
//         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//     }
//
//     NSData* data = (NSData*)command.arguments[0];
//     NSNumber* format = (NSNumber*)command.arguments[1];
//
//     NSString* hexString = [DataFormatter bytesToHexString:data.bytes withLength:data.length andFormat:format.boolValue];
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:hexString];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }
//
// #pragma mark - Logger
//
// /// Cброс накопленных логов в отладочную консоль
// -(void) loggerDumpLogs:(CDVInvokedUrlCommand *)command {
//
//     [Logger dumpLogs];
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }
//
// /// Принудительное удаление логов
// -(void) loggerPurgeLogs:(CDVInvokedUrlCommand *)command {
//
//     [Logger purgeLogs];
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }
//
//
// /// Возвращает число лог-записей (одна запись - одно событие)
// -(void) loggerGetCountLogs:(CDVInvokedUrlCommand *)command {
//
//     NSString* count = [Logger getCount];
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:count];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }
//
// /// флаг вывода логируемых событий в отладочную консоль в момент возникновения события.
// -(void) loggerSetRealTimeLog :(CDVInvokedUrlCommand *)command {
//
//     NSObject* enabledValue = [command.arguments firstObject];
//     if (enabledValue != nil && [enabledValue isKindOfClass:[NSNumber class]]) {
//         BOOL enabled = ((NSNumber*)enabledValue).boolValue;
//         [Logger realTimeLog:enabled];
//         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//     } else {
//         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//     }
// }
//
// /// включить/выключить логирование
// -(void) loggerPauseLogs :(CDVInvokedUrlCommand *)command{
//
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];;
//     [Logger pauseLogs];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }
//
// ///  текущее состояние ведения логов.
// -(void) loggerGetLogsPaused :(CDVInvokedUrlCommand *)command{
//
//     BOOL isPaused = [Logger logsPaused];
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool: isPaused];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }
//
// #pragma mark - Private methods
//
// -(BOOL) checkArguments:(NSArray*) args withTypes:(NSArray<Class>*) types {
//     if (args.count < types.count) {
//         return NO;
//     }
//     NSUInteger count = types.count;
//     for (int i = 0; i < count; i++) {
//         NSObject* obj = args[i];
//         Class type = types[i];
//         if ([obj isKindOfClass:type] == NO) {
//             return NO;
//         }
//     }
//     return YES;
// }
//
// - (void) sendErrorWithCallbackId:(NSString*) callbackId {
//     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
// }
//
// #pragma mark - Уведомления библиотеки
//
// - (void)registerForNotifications:(CDVInvokedUrlCommand *)command
// {
//     self.notificationsCallbackID = command.callbackId;
//
//     self.reactions = @{
//                        @"POWER_ON": ^NSDictionary *(NSNotification *notification) {
//                            return @{};
//                        },
//                        @"POWER_OFF": ^NSDictionary *(NSNotification *notification) {
//                            return @{};
//                        },
//                        @"POWER_RESET": ^NSDictionary *(NSNotification *notification) {
//                            return @{};
//                        },
//                        @"REFRESH_READERS_LIST": ^NSDictionary *(NSNotification *notification) {
//                            return @{};
//                        },
//                        @"SHOW_NOTIFICATION": ^NSDictionary *(NSNotification *notification) {
//                            ReaderProfile *reader = notification.userInfo[@"READER"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"READER"] = reader.identifier;
//                            return dict;
//                        },
//                        @"HIDE_NOTIFICATION": ^NSDictionary *(NSNotification *notification) {
//                            ReaderProfile *reader = notification.userInfo[@"READER"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"READER"] = reader.identifier;
//                            return [dict copy];
//                        },
//                        @"ADVERTISEMENT_STARTED": ^NSDictionary *(NSNotification *notification) {
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"ERROR"] = notification.userInfo[@"ERROR"];
//                            return [dict copy];
//                        },
//                        @"READER_UPDATE_STATE": ^NSDictionary *(NSNotification *notification) {
//                            ReaderProfile *reader = notification.userInfo[@"READER"];
//                            NSString *state = notification.userInfo[@"STATE"];
//                            Group *group = notification.userInfo[@"GROUP"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"READER"] = reader.identifier;
//                            dict[@"STATE"] = state;
//                            dict[@"GROUP"] = group.groupId;
//                            return [dict copy];
//                        },
//                        @"RSSI_CHANGED": ^NSDictionary *(NSNotification *notification) {
//                            ReaderProfile *reader = notification.userInfo[@"READER"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"READER"] = reader.identifier;
//                            return [dict copy];
//                        },
//                        @"USERID_FOR_GROUP_REQUIRED": ^NSDictionary *(NSNotification *notification) {
//                            Group *group = notification.userInfo[@"GROUP"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"GROUP"] = group.groupId;
//                            return [dict copy];
//                        },
//                        @"READER_EVENT": ^NSDictionary *(NSNotification *notification) {
//                            ReaderProfile *reader = notification.userInfo[@"READER"];
//                            NSString *type = notification.userInfo[@"TYPE"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"READER"] = reader.identifier;
//                            dict[@"TYPE"] = type;
//                            return [dict copy];
//                        },
//                        @"GROUP_SUSPENDED": ^NSDictionary *(NSNotification *notification) {
//                            Group *group = notification.userInfo[@"GROUP"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"GROUP"] = group.groupId;
//                            return [dict copy];
//                        },
//                        @"IMPORT": ^NSDictionary *(NSNotification *notification) {
//                            NSString *state = notification.userInfo[@"STATE"];
//                            NSNumber *result = notification.userInfo[@"RESULT"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"STATE"] = state;
//                            dict[@"RESULT"] = result;
//                            return [dict copy];
//                        },
//                        @"GROUP_EXPIRED": ^NSDictionary *(NSNotification *notification) {
//                            Group *group = notification.userInfo[@"GROUP"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"GROUP"] = group.groupId;
//                            return [dict copy];
//                        },
//                        @"CAN_MANUAL_SEND_USERID": ^NSDictionary *(NSNotification *notification) {
//                            ReaderProfile *reader = notification.userInfo[@"READER"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"READER"] = reader.identifier;
//                            return [dict copy];
//                        },
//                        @"GROUP_DISABLED": ^NSDictionary *(NSNotification *notification) {
//                            Group *group = notification.userInfo[@"GROUP"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"GROUP"] = group.groupId;
//                            return [dict copy];
//                        },
//                        @"ADVERTISEMENT_STATE": ^NSDictionary *(NSNotification *notification) {
//                            NSString *state = notification.userInfo[@"STATE"];
//                            NSError *error = notification.userInfo[@"ERROR"];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"STATE"] = state;
//                            dict[@"ERROR"] = [error localizedDescription];
//                            return [dict copy];
//                        },
//                        };
//
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(libraryNotification:) name:@"ESMART_VIRTUAL_CARD_EVENT" object:nil];
// }
//
// - (void)libraryNotification:(NSNotification *)notification
// {
//     NSString *event = notification.userInfo[@"EVT"];
//
//     if (!event) {
//         return;
//     }
//
//     NotificationHandler handler = self.reactions[event];
//
//     if (!handler) {
//         return;
//     }
//     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:handler(notification)];
//     dict[@"EVT"] = event;
//
//     CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
//     pluginResult.keepCallback = @YES;
//
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:self.notificationsCallbackID];
// }

@end
