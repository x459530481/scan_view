import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //注册我们自己的控件
    SmallScanViewPlugin.registerWith(registry:  self)
    ScanViewPlugin.registerWith(registry:  self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
