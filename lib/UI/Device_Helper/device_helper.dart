import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class IminDeviceHelper {
  static Future<bool> isIminDevice() async {
    try {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        // Check if the manufacturer or brand contains "IMIN" (case insensitive)
        String manufacturer = androidInfo.manufacturer.toLowerCase();
        String brand = androidInfo.brand.toLowerCase();
        String model = androidInfo.model.toLowerCase();

        return manufacturer.contains('imin') ||
            brand.contains('imin') ||
            model.contains('imin');
      }
      return false;
    } catch (e) {
      debugPrint("Error checking IMIN device: $e");
      return false;
    }
  }
}
