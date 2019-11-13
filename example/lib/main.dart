import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_view/scan_view.dart';
import 'package:scan_view/small_scan_view.dart';

void main() => runApp(MaterialApp(home: TextViewExample()));

class TextViewExample extends StatelessWidget {
  var myText = "Hello from Flutter!";
  SmallScanViewController scanViewController;
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
//                  child: TextView(
//                    onTextViewCreated: _onTextViewCreated,
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
                  child: Center(child: RaisedButton(onPressed: _doTorch, child: Text("手电"))))),

        ]));
  }

  var open = false;
  void _doTorch() {
    if(open){
      open = false;
//      this.scanViewController.invokeMethod('torchOff');
      this.scanViewController.setTorchOff();
    }else{
      open = true;
//      this.scanViewController.invokeMethod('torchOn');
      this.scanViewController.setTorchOn();
    }
  }

  void _setScanResult(String str){
//    setState(() {
    myText = str;
//    });

    showDialog(
        context: this.context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("错误1"),
            content: new Text(myText),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
//                    callback.onOk();
                  Navigator.of(context).pop();
                },
                child: new Text("确认"),
              ),
            ],
          );
        });

  }

//  void _onScanViewCreated(ScanViewController controller) {
//////    controller.setText('Hello from Android!');
////    int id = controller.id;
////    _platform = new MethodChannel("plugins.xiaosi.scanview_$id");
////    _platform.setMethodCallHandler((handler) {
////      switch (handler.method) {
////        case "getScanResult":
////          _setScanResult(handler.arguments.toString());
////          break;
////      }
////    });
//    controller.setResume();
//  }

  void _onSmallScanViewCreated(SmallScanViewController controller) {
    this.scanViewController = controller;
    this.scanViewController.setResume();
  }


}