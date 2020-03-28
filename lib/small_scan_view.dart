import 'dart:async';
import 'dart:async' as prefix0;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void SmallScanViewCreatedCallback(SmallScanViewController controller);
typedef void SmallScanViewScanResultCallback(String resultStr);

class SmallScanView extends StatefulWidget {
  const SmallScanView({
    Key key,
    this.onSmallScanViewCreated,
    this.onSmallScanViewScanResult,
  }) : super(key: key);

  final SmallScanViewCreatedCallback onSmallScanViewCreated;
  final SmallScanViewScanResultCallback onSmallScanViewScanResult;

  @override
  State<StatefulWidget> createState() => _SmallScanViewState();
}

class _SmallScanViewState extends State<SmallScanView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.xiaosi.smallscanview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }else if(defaultTargetPlatform == TargetPlatform.iOS){
      return UiKitView(viewType: "plugins.xiaosi.smallscanview",
          onPlatformViewCreated: _onPlatformViewCreated
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the small_scan_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onSmallScanViewCreated == null) {
      return;
    }

    widget.onSmallScanViewCreated(new SmallScanViewController._(id,widget));
  }
}

class SmallScanViewController {
  int id = 0;

  MethodChannel _channel;
  SmallScanViewController._(int id,SmallScanView scanView){
    this.id = id;
    this._channel = new MethodChannel('plugins.xiaosi.smallscanview_$id');
    this._channel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case "getScanResult":
          if (scanView.onSmallScanViewScanResult == null) {
            return;
          }
          scanView.onSmallScanViewScanResult(handler.arguments.toString());
//          _setScanResult(handler.arguments.toString());
          break;
      }
    });
  }

  Future<void> setScanResume() async {
    return this._channel.invokeMethod('scanResume');
  }
  Future<void> setScanPause() async {
    return this._channel.invokeMethod('scanPause');
  }
  Future<void> setTorchOn() async {
    return this._channel.invokeMethod('torchOn');
  }
  Future<void> setTorchOff() async {
    return this._channel.invokeMethod('torchOff');
  }
  Future<void> setShowViewFinder() async {
    return this._channel.invokeMethod('showViewFinder');
  }
  Future<void> setHideViewFinder() async {
    return this._channel.invokeMethod('hideViewFinder');
  }
  Future<void> setScanClose() async {
    return this._channel.invokeMethod('scanClose');
  }
  Future<void> setScanOpen() async {
    return this._channel.invokeMethod('scanOpen');
  }
}