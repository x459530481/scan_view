//
//  ScanView.swift
//  Runner
//
//  Created by tony on 2019/11/13.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Flutter
import UIKit
import AVFoundation
import SnapKit
import Toast_Swift

class ScanView: NSObject,FlutterPlatformView {
    
    var scanning = false
    
    let frameC: CGRect;
    let viewId: Int64;
    var messenger: FlutterBinaryMessenger!
    
    var scanview: UIView = UIView()
    
    var methodChannel:FlutterMethodChannel?
    
    init(_ frame: CGRect,viewID: Int64,args :Any?, binaryMessenger: FlutterBinaryMessenger) {
        self.frameC = frame;
        self.viewId = viewID;
        self.messenger=binaryMessenger;
        
//        super.init()
//        self.buildScanerxx()
    }
    
    func view() -> UIView {
        buildScanerxx()
        return scanview
    }
    
    
    func initMethodChannel(){
        print("viewId:\(viewId)")
        methodChannel = FlutterMethodChannel.init(name: "plugins.xiaosi.scanview_\(viewId)",binaryMessenger: messenger);
        methodChannel!.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if(call.method == "torchOn"){
                self.torchOn()
            }else if(call.method == "torchOff"){
                self.torchOff()
            }else if(call.method == "scanPause"){
                self.pauseScan()
            }else if(call.method == "scanResume"){
                self.resumeScan()
            }else if(call.method == "showViewFinder"){
                self.barcodeView.isHidden = false
            }else if(call.method == "hideViewFinder"){
                self.barcodeView.isHidden = true
            }else if(call.method == "scanClose"){
                self.closeScan()
            }else if(call.method == "scanOpen"){
                self.openScan()
            }
        });
    }
    
    func torchOn() {
        let device = AVCaptureDevice.default(for: .video)
        if device==nil{
            return
        }
        do{
            //锁定设备以便进行手电筒状态修改
            try device?.lockForConfiguration()
            //设置手电筒模式为亮灯（On）
            device?.torchMode = .on
            //解锁设备锁定以便其他APP做配置更新
            device?.unlockForConfiguration()
        }catch{
            return
        }
    }
    
    func torchOff() {
        let device = AVCaptureDevice.default(for: .video)
        if device==nil{
            return
        }
        do{
            //锁定设备以便进行手电筒状态修改
            try device?.lockForConfiguration()
            //设置手电筒模式为亮灯（On）
            device?.torchMode = .off
            //解锁设备锁定以便其他APP做配置更新
            device?.unlockForConfiguration()
        }catch{
            return
        }
    }
    
    // MARK: - 扫码相关
    //相机显示视图
    var cameraView: UIView!
    //创建AVCaptureSession
    let captureSession = AVCaptureSession()
    //屏幕扫描区域视图
    let scanWidth = UIScreen.main.bounds.size.width * 0.6
    let scanHeight = UIScreen.main.bounds.size.width * 0.6
    let barcodeView = ScanerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.6, height: UIScreen.main.bounds.size.width * 0.6))
    
//     let barcodeView = ScanerView(frame: CGRect(x: UIScreen.main.bounds.size.width * 0.15, y: UIScreen.main.bounds.size.height * 0.15, width: UIScreen.main.bounds.size.width * 0.6, height: UIScreen.main.bounds.size.height * 0.7))
    
    //扫描线
    let scanLine = UIImageView()
    var timer: Timer!
    var cameraViewHeight: CGFloat = UIScreen.main.bounds.size.height
    
    var iconTxt: UILabel!
    var dealerName = "" {
        didSet {
            self.iconTxt.text = dealerName
        }
    }
    
    // MARK: - 扫码相关的方法
    private func buildScanerxx() {
        initMethodChannel()
        
        print(NSLocalizedString("1111111111", comment:"111111111111111"))
        cameraView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: cameraViewHeight))
        self.scanview.addSubview(cameraView)
        cameraView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scanview)
            make.left.right.equalTo(self.scanview)
            make.height.equalTo(self.scanview)
        }
        initView()
        let captureDevice = AVCaptureDevice.default(for: .video)
        let input: AVCaptureDeviceInput
        //创建媒体数据输出流
        let output = AVCaptureMetadataOutput()
        //捕捉异常
        do {
            //创建输入流
            input = try AVCaptureDeviceInput(device: captureDevice!)
            //            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            //                for inputItem in inputs {
            //                    captureSession.removeInput(inputItem)
            //                }
            //            }
                        if captureSession.inputs.count == 0 {
                            self.captureSession.addInput(input)
                        }
            //            //把输入流添加到会话
            //            captureSession.addInput(input)
                        
            //            if let outputs = captureSession.outputs as? [AVCaptureMetadataOutput] {
            //               for outputItem in outputs {
            //                   captureSession.removeOutput(outputItem)
            //               }
            //            }
                        if captureSession.outputs.count == 0 {
                            self.captureSession.addInput(output)
                        }
            //            //把输出流添加到会话
            //            captureSession.addOutput(output)
        } catch {
            print(NSLocalizedString("异常", comment:"异常"))
            let err = error as NSError
            if (err.code == -11852) {//无法使用“后置镜头
                self.scanview.makeToast(NSLocalizedString("您没有权限访问相机, 请在设置中开启访问权限", comment:"您没有权限访问相机, 请在设置中开启访问权限"))
            }
            return
        }
        //创建串行队列
        let dispatchQueue = DispatchQueue(label: "queue", attributes: [])
        //设置输出流的代理
        output.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        //设置输出媒体的数据类型
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.pdf417]
        //创建预览图层
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //设置预览图层的填充方式
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //设置预览图层的frame
        videoPreviewLayer.frame = cameraView.bounds
        //将预览图层添加到预览视图上
        cameraView.layer.insertSublayer(videoPreviewLayer, at: 0)
        //设置扫描范围
        output.rectOfInterest = CGRect(x: 0.15, y: 0.15, width: 0.7, height: 0.7)
    }
    //初始化视图
    private func initView() {
        barcodeView.backgroundColor = UIColor.clear
        cameraView.addSubview(barcodeView)
        barcodeView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cameraView)
            make.centerX.equalTo(cameraView)
            make.width.equalTo(self.scanWidth)
            make.height.equalTo(scanWidth)
        }
        //设置扫描线
        scanLine.frame = CGRect(x: 0, y: 0, width: barcodeView.frame.size.width, height: 3)
        scanLine.contentMode = .center
        scanLine.image = UIImage(named: "QRCodeScanLine")
        //添加扫描线图层
        barcodeView.addSubview(scanLine)
        scanLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(barcodeView)
            make.top.equalTo(0)
            make.height.equalTo(3)
            make.width.equalTo(barcodeView).multipliedBy(0.8)
        }
        createBackGroundView()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveScannerLayer(_:)), userInfo: nil, repeats: true)
//        timer.fire()
    }
    private func createBackGroundView() {
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: cameraViewHeight * 0.15))
        let bottomView = UIView(frame: CGRect(x: 0, y: cameraViewHeight * 0.85, width: UIScreen.main.bounds.size.width, height: cameraViewHeight * 0.15))
        let leftView = UIView(frame: CGRect(x: 0, y: cameraViewHeight * 0.15, width: UIScreen.main.bounds.size.width * 0.15, height: cameraViewHeight * 0.7))
        let rightView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width * 0.85, y: cameraViewHeight * 0.15, width: UIScreen.main.bounds.size.width * 0.15, height: cameraViewHeight * 0.7))
        iconTxt = UILabel(frame: CGRect(x: 35, y: 0, width: UIScreen.main.bounds.width - 35, height: 22))
        iconTxt.font = UIFont.boldSystemFont(ofSize: 16)
        iconTxt.textColor = UIColor.white
        iconTxt.text = ""
        iconTxt.textAlignment = .left
        iconTxt.center = topView.center
        topView.addSubview(iconTxt)
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        cameraView.addSubview(topView)
        cameraView.addSubview(bottomView)
        cameraView.addSubview(leftView)
        cameraView.addSubview(rightView)
        topView.snp.makeConstraints{ (make) in
            make.top.left.right.equalTo(cameraView)
            make.bottom.equalTo(barcodeView).inset(self.scanHeight)
        }
        bottomView.snp.makeConstraints{ (make) in
            make.bottom.left.right.equalTo(cameraView)
            make.top.equalTo(barcodeView).inset(self.scanHeight)
        }
        leftView.snp.makeConstraints{ (make) in
            make.left.equalTo(cameraView)
            make.top.equalTo(barcodeView)
            make.right.equalTo(barcodeView).inset(self.scanWidth)
            make.bottom.equalTo(barcodeView)
        }
        rightView.snp.makeConstraints{ (make) in
            make.right.equalTo(cameraView)
            make.top.equalTo(barcodeView)
            make.left.equalTo(barcodeView).inset(self.scanWidth)
            make.bottom.equalTo(barcodeView)
        }
    }
    @objc private func moveScannerLayer(_ timer: Timer) {
        UIView.animate(withDuration: 0) {
            self.scanLine.snp.updateConstraints { (make) in
                make.top.equalTo(0)
            }
            self.barcodeView.layoutIfNeeded()
        }
        UIView.animate(withDuration: 2.0) {
            self.scanLine.snp.updateConstraints { (make) in
                make.top.equalTo(self.barcodeView.bounds.height)
            }
            self.barcodeView.layoutIfNeeded()
        }
    }
    func scannerStart() {
        captureSession.startRunning()
    }
    func scannerStop() {
        captureSession.stopRunning()
    }
 //public
    func openScan() {
        scanning = true
        scannerStart()
        if self.timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveScannerLayer(_:)), userInfo: nil, repeats: true)
        }
        timer.fire()
    }
    func closeScan() {
        scanning = false
        scannerStop()
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    func resumeScan() {
        scanning = true
          //scannerStart()
//          if timer != nil {
//              timer.fireDate = Date.distantPast//计时器继续
//          }
       }
       func pauseScan() {
           scanning = false
          //scannerStop()
//          if timer != nil {
//               timer.fireDate = Date.distantFuture// 计时器暂停
//          }
       }
    @objc private func processResult(_ codeStr: String) {
//        logInfo(codeStr)
//        scanResult?(codeStr)
        if(scanning){
            scanning = false
            methodChannel?.invokeMethod("getScanResult", arguments: codeStr)
        }
    }
    deinit {
//        logDebug("\(type(of: self)): Deinited")
    }
}

extension ScanView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count > 0 {
            let metaData = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            //            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            let sacnStr = metaData.stringValue
//            self.scannerStop()
            DispatchQueue.main.async(execute: {
                self.processResult(sacnStr ?? "")
            })
        }
    }
}

