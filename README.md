# scan_view

A new Flutter plugin.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

### demo
ScanView为可全屏大取景框（取景框为正方形居中，宽高为宽度的70%）

SmallScanView为窄框取景（取景框为长方形居中，宽为宽度的70%、高度176写死了，有需要变更的自行修改源码）


ScanViewController和SmallScanViewController有六个方法

setTorchOn()//手电筒开

setTorchOff()//手电筒关

setScanResume()//恢复扫码

setScanPause()//暂停扫码

setShowViewFinder()//显示取景框

setHideViewFinder() //隐藏取景框


class DemoExample extends StatelessWidget {

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

      this.smallScanViewController.setTorchOff();
      
    }else{
    
      open = true;

      this.smallScanViewController.setTorchOn();
      
    }
    
  }
  


  void _setScanResult(String str){
  
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
  

  void _onSmallScanViewCreated(SmallScanViewController controller) {
  
    this.smallScanViewController = controller;
    
    this.smallScanViewController.setScanResume();
    
  }
  
}

