
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNEsmartSpec.h"

@interface Esmart : NSObject <NativeEsmartSpec>
#else
#import <React/RCTBridgeModule.h>

@interface Esmart : NSObject <RCTBridgeModule>
#endif

@end
