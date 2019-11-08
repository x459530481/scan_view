#import "ScanViewPlugin.h"
#import <scan_view/scan_view-Swift.h>

@implementation ScanViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScanViewPlugin registerWithRegistrar:registrar];
}
@end
