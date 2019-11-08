package com.xiaosi.scan_view_example

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.widget.Toast

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    var bol = true;
    for (index in 1 until permissions.size){
      if(ActivityCompat.checkSelfPermission(this,permissions[index]) == PackageManager.PERMISSION_DENIED){
        bol = false
      }
    }
    if (bol) {
      //已经获取到权限  获取用户媒体资源
      GeneratedPluginRegistrant.registerWith(this)
    }else{
      myRequestPermission()
    }

  }
  //可以添加多个权限申请
  val permissions = arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE,
          Manifest.permission.CAMERA,
          Manifest.permission.ACCESS_COARSE_LOCATION,
          Manifest.permission.READ_PHONE_STATE,
          Manifest.permission.WRITE_EXTERNAL_STORAGE
  )
  private fun myRequestPermission() {

    ActivityCompat.requestPermissions(this,permissions,1)
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
    if (grantResults.size == 0) {
      GeneratedPluginRegistrant.registerWith(this)
      return
    }
    if (requestCode == 1) {
      var bol = true;
      for (index in 1 until grantResults.size){
        if(grantResults[index] == PackageManager.PERMISSION_DENIED){
          bol = false
        }
      }
      if (bol) {

        //已经获取到权限  获取用户媒体资源
        GeneratedPluginRegistrant.registerWith(this)
      }else{
        myRequestPermission();
        Toast.makeText(this, "权限暂未授权", Toast.LENGTH_LONG);
//        ToastUtils.show(this, getString(R.string.user_permission_not_allow_tips))
      }
    } else {
      super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }
  }
}
