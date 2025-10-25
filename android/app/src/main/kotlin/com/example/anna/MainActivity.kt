package com.example.anna
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Bundle;
import android.util.Log;

import java.util.HashMap;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

//class MainActivity: FlutterActivity()
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.annai/usb"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getUsbDevices" -> {
                        result.success(getUsbDevices())
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun getUsbDevices(): List<Map<String, Any>> {
        val usbManager = getSystemService(USB_SERVICE) as UsbManager
        val usbDeviceList: HashMap<String, UsbDevice> = usbManager.deviceList
        val deviceList = mutableListOf<Map<String, Any>>()

        for (usbDevice in usbDeviceList.values) {
            val vid = usbDevice.vendorId
            val pid = usbDevice.productId
            val deviceInfo = mapOf(
                "vid" to vid,
                "pid" to pid,
                "deviceName" to (usbDevice.deviceName ?: "Unknown"),
                "productName" to (usbDevice.productName ?: "Unknown")
            )
            deviceList.add(deviceInfo)
            Log.d("USB Info", "Vendor ID (VID): $vid, Product ID (PID): $pid")
        }

        return deviceList
    }
}