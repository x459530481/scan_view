import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_view/scan_view.dart';
import 'package:scan_view/small_scan_view.dart';

void main() => runApp(MaterialApp(home: TextViewExample()));

class TextViewExample extends StatelessWidget {
//  ScanViewController scanViewController;
  SmallScanViewController smallScanViewController;
  var context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
        appBar: AppBar(title: const Text('Flutter TextView example')),
        body: Column(children: [
          Center(
              child: Container(
                  width: 480.0,
                  height: 176.0,
//                  child: ScanView(
//                    onScanViewCreated: _onScanViewCreated,
//                    onScanViewScanResult: _setScanResult,
//                  )
                  child: SmallScanView(
                    onSmallScanViewCreated: _onSmallScanViewCreated,
                    onSmallScanViewScanResult: _setScanResult,
                  )
              )
          ),
          Expanded(
              flex: 3,
              child: Container(
                  color: Colors.blue[100],
                  child: Center(child: RaisedButton(onPressed: _doTorch, child: Text("手电"))))),     Expanded(
              flex: 3,
              child: Container(
                  color: Colors.blue[100],
                  child: Center(child: RaisedButton(onPressed: _doResume, child: Text("doResume"))))),

        ]));
  }

  var open = false;
  void _doTorch() {
    if(open){
      open = false;
//      this.scanViewController.setTorchOff();
      this.smallScanViewController.setTorchOff();
    }else{
      open = true;
//      this.scanViewController.setTorchOn();
      this.smallScanViewController.setTorchOn();
    }
  }

  void _doResume() {
    Future.delayed(Duration(milliseconds: 1000)).then((e) {
      this.smallScanViewController.setScanResume();
    });
  }

  void _setScanResult(String str){
    smallScanViewController.setScanPause();
    showDialog(
        context: this.context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("提示"),
            content: new Text(str),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("确认"),
              ),
            ],
          );
        });

  }

//  void _onScanViewCreated(ScanViewController controller) {
//    this.scanViewController = controller;
//    this.scanViewController.setResume();
//  }

  void _onSmallScanViewCreated(SmallScanViewController controller) {
    this.smallScanViewController = controller;
    Future.delayed(Duration(milliseconds: 500)).then((e) {
      this.smallScanViewController.setScanOpen();
    });
  }
}