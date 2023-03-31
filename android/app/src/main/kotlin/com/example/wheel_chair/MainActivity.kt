package com.example.wheel_chair




import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.telephony.SmsManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        }
override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(
                            Manifest.permission.SEND_SMS)
                    != PackageManager.PERMISSION_GRANTED) {

                // Should we show an explanation?
                if (shouldShowRequestPermissionRationale(
                                Manifest.permission.SEND_SMS)) {

                    // Show an explanation to the user asynchronously -- don't block
                    // this thread waiting for the user's response! After the user
                    // sees the explanation, try again to request the permission.
                } else {

                    // No explanation needed, we can request the permission.
                    requestPermissions(arrayOf(Manifest.permission.SEND_SMS),
                            0)

                    // MY_PERMISSIONS_REQUEST_SEND_SMS is an
                    // app-defined int constant. The callback method gets the
                    // result of the request.
                }
            }
        }
        MethodChannel(getBinaryMessenger(), CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "send") {
                val num = call.argument<String>("phone")
                val msg = call.argument<String>("msg")
                sendSMS(num, msg, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBinaryMessenger(): BinaryMessenger {
        return flutterEngine!!.dartExecutor.binaryMessenger
    }

    private fun sendSMS(phoneNo: String?, msg: String?, result: MethodChannel.Result) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNo, null, msg, null, null)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "")
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            0 -> {

                // If request is cancelled, the result arrays are empty.
                if (grantResults.isNotEmpty()
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    // permission was granted, yay! Do the
                    // contacts-related task you need to do.
                } else {

                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                }
                return
            }
        }
    }

    companion object {
        private const val CHANNEL = "sendSms"
    }
}

