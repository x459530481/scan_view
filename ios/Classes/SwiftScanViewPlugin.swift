import Flutter
import UIKit

public class SwiftScanViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    //let channel = FlutterMethodChannel(name: "scan_view", binaryMessenger: registrar.messenger())
    //let instance = SwiftScanViewPlugin()
    //registrar.addMethodCallDelegate(instance, channel: channel)

    let messenger = registrar.messenger() as! (NSObject & FlutterBinaryMessenger)
    registrar.register(SmallScanViewFactory(messenger:messenger),withId: "plugins.xiaosi.smallscanview");

    registrar.register(ScanViewFactory(messenger:messenger),withId: "plugins.xiaosi.scanview");
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
