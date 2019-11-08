import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void ScanViewCreatedCallback(ScanViewController controller);
typedef void ScanViewScanResultCallback(String resultStr);

class ScanView extends StatefulWidget {
  const ScanView({
    Key key,
    this.onScanViewCreated,
    this.onScanViewScanResult,
  }) : super(key: key);

  final ScanViewCreatedCallback onScanViewCreated;
  final ScanViewScanResultCallback onScanViewScanResult;

  @override
  State<StatefulWidget> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.xiaosi.scanview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onScanViewCreated == null) {
      return;
    }

    widget.onScanViewCreated(new ScanViewController._(id,widget));
  }
}

class ScanViewController {
  int id = 0;

  MethodChannel _channel;
  ScanViewController._(int id,ScanView scanView){
    this.id = id;
    this._channel = new MethodChannel('plugins.xiaosi.scanview_$id');
    this._channel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case "getScanResult":
          if (scanView.onScanViewScanResult == null) {
            return;
          }
          scanView.onScanViewScanResult(handler.arguments.toString());
//          _setScanResult(handler.arguments.toString());
          break;
      }
    });
  }

  Future<void> setResume() async {
    return _channel.invokeMethod('scanResume');
  }
  Future<void> setScanPause() async {
    return _channel.invokeMethod('scanPause');
  }
  Future<void> setTorchOn() async {
    return _channel.invokeMethod('torchOn');
  }
  Future<void> setTorchOff() async {
    return _channel.invokeMethod('torchOff');
  }
  Future<void> setShowViewFinder() async {
    return _channel.invokeMethod('showViewFinder');
  }
  Future<void> setHideViewFinder() async {
    return _channel.invokeMethod('hideViewFinder');
  }
}