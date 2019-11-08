package com.xiaosi.scan_view

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class ScanViewPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      registrar
              .platformViewRegistry()
              .registerViewFactory(
                      "plugins.xiaosi.scanview", ScanViewFactory(registrar.messenger()));

      registrar
              .platformViewRegistry()
              .registerViewFactory(
                      "plugins.xiaosi.smallscanview", SmallScanViewFactory(registrar.messenger()));
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }
}
