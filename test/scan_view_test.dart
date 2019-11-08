import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scan_view/scan_view.dart';

void main() {
  const MethodChannel channel = MethodChannel('scan_view');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ScanView.platformVersion, '42');
  });
}
