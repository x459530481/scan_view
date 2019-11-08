package com.xiaosi.scan_view;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.util.AttributeSet;
import android.util.Xml;
import android.view.View;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.ResultPoint;
import com.journeyapps.barcodescanner.BarcodeCallback;
import com.journeyapps.barcodescanner.BarcodeResult;
import com.journeyapps.barcodescanner.DecoratedBarcodeView;
import com.journeyapps.barcodescanner.DefaultDecoderFactory;

import org.xmlpull.v1.XmlPullParser;

import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import static io.flutter.plugin.common.MethodChannel.Result;

public class FlutterScanView implements PlatformView, MethodCallHandler  {
    private final DecoratedBarcodeView scanView;
    private final MethodChannel methodChannel;

    FlutterScanView(Context context, BinaryMessenger messenger, int id){

//        LinearLayout linearLayout = (LinearLayout) LayoutInflater.from(context).inflate(R.layout.scan_view, null, false);
//        DecoratedBarcodeView tmpView = (DecoratedBarcodeView) linearLayout.findViewById(R.id.zxing_barcode_scanner);



        @SuppressLint("ResourceType") XmlPullParser parser = context.getResources().getXml(R.layout.scan_view);
//        @SuppressLint("ResourceType") XmlPullParser parser = context.getResources().getXml(R.layout.small_scan_view);
        AttributeSet attributes = Xml.asAttributeSet(parser);
        int type;
        try {
            while ((type = parser.next()) != XmlPullParser.START_TAG &&
                    type != XmlPullParser.END_DOCUMENT) {
                // Empty
            }
            while ((type = parser.next()) != XmlPullParser.START_TAG &&
                    type != XmlPullParser.END_DOCUMENT) {
                // Empty
            }
        }catch (Exception ex){
            ex.printStackTrace();
        }


//        scanView = new DecoratedBarcodeView(context);
        scanView = new DecoratedBarcodeView(context,attributes);
        scanView.initializeFromIntent(new Intent());
        scanView.decodeContinuous(new BarcodeCallback() {
            @Override
            public void barcodeResult(BarcodeResult result) {
                System.out.println(result.toString());
                methodChannel.invokeMethod("getScanResult", result.getResult().getText());
            }

            @Override
            public void possibleResultPoints(List<ResultPoint> resultPoints) {

            }
        });

        Vector v = new Vector();
        v.add(BarcodeFormat.QR_CODE);
        v.add(BarcodeFormat.CODE_128);
        v.add(BarcodeFormat.EAN_8);
        Enumeration e = v.elements();
        Collection<BarcodeFormat> formats = Collections.list(e);

        scanView.getBarcodeView().setDecoderFactory(new DefaultDecoderFactory(formats));
        methodChannel = new MethodChannel(messenger, "plugins.xiaosi.scanview_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return scanView;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, Result result) {
        switch (methodCall.method) {
            case "torchOn":
                scanView.setTorchOn();
                break;
            case "torchOff":
                scanView.setTorchOff();
                break;
            case "scanPause":
                scanView.pause();
                break;
            case "scanResume":
                scanView.resume();
                break;
            case "showViewFinder":
                scanView.getViewFinder().setVisibility(View.VISIBLE);
                break;
            case "hideViewFinder":
                scanView.getViewFinder().setVisibility(View.GONE);
                break;
            default:
                result.notImplemented();
        }

    }

//    private void setText(MethodCall methodCall, Result result) {
//        String text = (String) methodCall.arguments;
//        textView.setText(text);
//        result.success(null);
//    }

    @Override
    public void dispose() {
        scanView.pause();
        scanView.setTorchOff();
    }
}

