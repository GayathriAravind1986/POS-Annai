import 'package:flutter/services.dart';

class UsbHelper {
  static const platform = MethodChannel("com.example.myapp/usb");

  static Future<String> getUsbDevices() async {
    try {
      final devices = await platform.invokeMethod<String>("getUsbDevices");
      return devices ?? "No devices found";
    } on PlatformException catch (e) {
      return "Failed to get USB devices: ${e.message}";
    }
  }
}
