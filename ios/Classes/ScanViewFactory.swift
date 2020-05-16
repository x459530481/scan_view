//
//  ScanViewFactory.swift
//  Runner
//
//  Created by tony on 2019/11/13.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Flutter
import Foundation

class ScanViewFactory : NSObject,FlutterPlatformViewFactory{
    
    var messenger: FlutterBinaryMessenger!
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        print(NSLocalizedString("555555", comment:"5555555"))
        return ScanView(frame,viewID : viewId , args : args,binaryMessenger:messenger);
    }
    
    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?) {
        super.init()
        self.messenger = messenger
    }
}
