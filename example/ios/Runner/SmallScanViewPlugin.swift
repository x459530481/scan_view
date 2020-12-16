//
//  SmallScanViewPlugin.swift
//  Runner
//
//  Created by tony on 2019/11/13.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Flutter
import Foundation

class SmallScanViewPlugin {
    static func registerWith(registry:FlutterPluginRegistry) {
        let pluginKey = "Small_Scan_View_Plugin";
        if (registry.hasPlugin(pluginKey)) {return};
        let registrar = registry.registrar(forPlugin: pluginKey);
        let messenger = registrar?.messenger() as! (NSObject & FlutterBinaryMessenger)
        registrar?.register(SmallScanViewFactory(messenger:messenger),withId: "plugins.xiaosi.smallscanview");
        
    }
}
