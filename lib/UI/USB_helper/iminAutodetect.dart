import 'package:simple/UI/USB_helper/USB_Helper.dart';

class IminDeviceDetector {
  // Common IMIN device manufacturer VIDs (if known)
  static const List<int> KNOWN_IMIN_VIDS = [
    // Add known IMIN manufacturer VIDs here if you find them
    // For example: 0x1234, 0x5678, etc.
    // Leave empty if unknown - we'll detect all devices
  ];

  // Store detected IMIN devices dynamically
  static List<Map<String, int>> detectedIminDevices = [];

  // Method to auto-detect and store IMIN device VID/PID
  static Future<List<Map<String, int>>> autoDetectIminDevice() async {
    try {
      // Get all USB devices
      String devices = await UsbHelper.getUsbDevices();
      List<Map<String, int>> allDevices = parseUsbDevices(devices);

      // If we have known IMIN VIDs, filter by them
      if (KNOWN_IMIN_VIDS.isNotEmpty) {
        List<Map<String, int>> possibleIminDevices = allDevices
            .where((device) => KNOWN_IMIN_VIDS.contains(device['vid']))
            .toList();

        if (possibleIminDevices.isNotEmpty) {
          detectedIminDevices = possibleIminDevices;
          return possibleIminDevices;
        }
      }

      // If no known VIDs or no matches found, return all devices
      // User will need to identify their IMIN device manually
      detectedIminDevices = allDevices;
      return allDevices;
    } catch (e) {
      print("Error auto-detecting IMIN device: $e");
      return [];
    }
  }

  // Method to manually set IMIN device after user selection
  static void setIminDevice(int vid, int pid) {
    detectedIminDevices = [
      {'vid': vid, 'pid': pid}
    ];
    // Optionally save to SharedPreferences for future use
    _saveIminDeviceToPrefs(vid, pid);
  }

  // Check if any detected devices match current USB devices
  static bool isIminDeviceConnected(List<Map<String, int>> currentDevices) {
    if (detectedIminDevices.isEmpty) return false;

    return currentDevices.any((device) => detectedIminDevices.any(
        (iminDevice) =>
            device['vid'] == iminDevice['vid'] &&
            device['pid'] == iminDevice['pid']));
  }

  // Get the connected IMIN device
  static Map<String, int>? getConnectedIminDevice(
      List<Map<String, int>> currentDevices) {
    for (var device in currentDevices) {
      for (var iminDevice in detectedIminDevices) {
        if (device['vid'] == iminDevice['vid'] &&
            device['pid'] == iminDevice['pid']) {
          return device;
        }
      }
    }
    return null;
  }

  // Helper method to parse USB devices
  static List<Map<String, int>> parseUsbDevices(String devices) {
    List<Map<String, int>> deviceList = [];
    List<String> lines = devices.split('\n');

    for (String line in lines) {
      if (line.trim().isNotEmpty) {
        RegExp regex = RegExp(r'VID: (\d+), PID: (\d+)');
        Match? match = regex.firstMatch(line);
        if (match != null) {
          deviceList.add({
            'vid': int.parse(match.group(1)!),
            'pid': int.parse(match.group(2)!),
          });
        }
      }
    }
    return deviceList;
  }

  // Save to SharedPreferences (optional - for persistence)
  static Future<void> _saveIminDeviceToPrefs(int vid, int pid) async {
    // Implement SharedPreferences saving if needed
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('imin_vid', vid);
    // await prefs.setInt('imin_pid', pid);
  }

  // Load from SharedPreferences (optional - for persistence)
  static Future<void> loadSavedIminDevice() async {
    // Implement SharedPreferences loading if needed
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int? vid = prefs.getInt('imin_vid');
    // int? pid = prefs.getInt('imin_pid');
    // if (vid != null && pid != null) {
    //   detectedIminDevices = [{'vid': vid, 'pid': pid}];
    // }
  }
}
