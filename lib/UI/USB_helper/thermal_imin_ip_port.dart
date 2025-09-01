import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/UI/IminHelper/printer_helper.dart';

class IminD4ThermalPrinter {
  // Common thermal printer network ports
  static const List<int> COMMON_PRINTER_PORTS = [9100, 515, 631, 8080, 80];

  // Store printer configuration
  static String? printerIP;
  static int? printerPort;
  static bool isPrinterConfigured = false;

  // Method to scan for network thermal printers
  static Future<List<String>> scanForNetworkPrinters(String subnet) async {
    List<String> foundPrinters = [];
    List<Future<String?>> scanTasks = [];

    // Scan IP range (e.g., 192.168.1.1 to 192.168.1.254)
    for (int i = 1; i <= 254; i++) {
      String ip = "$subnet.$i";
      scanTasks.add(_checkPrinterAtIP(ip));
    }

    try {
      List<String?> results = await Future.wait(scanTasks);
      foundPrinters = results.where((ip) => ip != null).cast<String>().toList();
    } catch (e) {
      print("Error scanning network: $e");
    }

    return foundPrinters;
  }

  // Check if thermal printer exists at specific IP
  static Future<String?> _checkPrinterAtIP(String ip) async {
    for (int port in COMMON_PRINTER_PORTS) {
      try {
        Socket socket =
            await Socket.connect(ip, port, timeout: const Duration(seconds: 2));
        await socket.close();
        return "$ip:$port";
      } catch (e) {
        // Connection failed, try next port
        continue;
      }
    }
    return null;
  }

  // Test connection to specific printer
  static Future<bool> testPrinterConnection(String ip, int port) async {
    try {
      Socket socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 3));

      // Send a simple test command (ESC/POS initialize)
      List<int> testCommand = [0x1B, 0x40]; // ESC @ (Initialize printer)
      socket.add(testCommand);
      await socket.flush();
      await socket.close();

      return true;
    } catch (e) {
      print("Printer test failed for $ip:$port - $e");
      return false;
    }
  }

  // Configure printer IP and port
  static void configurePrinter(String ip, int port) {
    printerIP = ip;
    printerPort = port;
    isPrinterConfigured = true;
    // Save to SharedPreferences for persistence
    _savePrinterConfig(ip, port);
  }

  // Send print data to network thermal printer
  static Future<bool> printToThermalPrinter(Uint8List imageData) async {
    if (!isPrinterConfigured || printerIP == null || printerPort == null) {
      throw Exception("Printer not configured");
    }

    try {
      Socket socket = await Socket.connect(printerIP!, printerPort!,
          timeout: const Duration(seconds: 5));

      // ESC/POS commands for image printing
      List<int> commands = [];

      // Initialize printer
      commands.addAll([0x1B, 0x40]); // ESC @

      // Set alignment center
      commands.addAll([0x1B, 0x61, 0x01]); // ESC a 1

      // Here you would convert imageData to ESC/POS format
      // This is a simplified example - actual implementation depends on your image format
      commands.addAll(imageData);

      // Feed and cut
      commands.addAll([0x1B, 0x64, 0x03]); // ESC d 3 (feed 3 lines)
      commands.addAll([0x1D, 0x56, 0x00]); // GS V 0 (full cut)

      socket.add(commands);
      await socket.flush();
      await socket.close();

      return true;
    } catch (e) {
      print("Print to thermal printer failed: $e");
      return false;
    }
  }

  // Save printer configuration
  static Future<void> _savePrinterConfig(String ip, int port) async {
    // Implement SharedPreferences saving
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('thermal_printer_ip', ip);
    // await prefs.setInt('thermal_printer_port', port);
  }

  // Load printer configuration
  static Future<void> loadPrinterConfig() async {
    // Implement SharedPreferences loading
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // printerIP = prefs.getString('thermal_printer_ip');
    // printerPort = prefs.getInt('thermal_printer_port');
    // isPrinterConfigured = printerIP != null && printerPort != null;
  }

  // Get current network subnet
  static Future<String> getCurrentSubnet() async {
    try {
      for (NetworkInterface interface in await NetworkInterface.list()) {
        for (InternetAddress addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            List<String> parts = addr.address.split('.');
            if (parts.length == 4) {
              return "${parts[0]}.${parts[1]}.${parts[2]}";
            }
          }
        }
      }
    } catch (e) {
      print("Error getting subnet: $e");
    }
    return "192.168.1"; // Default fallback
  }
}

// Add these methods to your ThermalReceiptDialog class:

// Scan for thermal printers on network
Future<void> _scanForThermalPrinters(BuildContext context) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: blueColor),
            SizedBox(height: 16),
            Text("Scanning for thermal printers on network...",
                style: TextStyle(color: whiteColor)),
            SizedBox(height: 8),
            Text("This may take a few moments",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );

    String subnet = await IminD4ThermalPrinter.getCurrentSubnet();
    List<String> foundPrinters =
        await IminD4ThermalPrinter.scanForNetworkPrinters(subnet);

    Navigator.of(context).pop(); // Close scanning dialog

    if (foundPrinters.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No Printers Found'),
          content: Text(
              'No thermal printers found on network $subnet.x\n\nTry:\n• Check printer is powered on\n• Verify network connection\n• Manual IP configuration'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _manualPrinterSetup(context);
              },
              child: const Text('Manual Setup'),
            ),
          ],
        ),
      );
      return;
    }

    // Show found printers for selection
    String? selectedPrinter = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Found ${foundPrinters.length} Printer(s)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select your thermal printer:'),
            const SizedBox(height: 16),
            ...foundPrinters
                .map((printer) => ListTile(
                      dense: true,
                      title: Text(printer.split(':')[0]),
                      subtitle: Text('Port: ${printer.split(':')[1]}'),
                      onTap: () => Navigator.of(ctx).pop(printer),
                      leading: const Icon(Icons.print),
                    ))
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedPrinter != null) {
      List<String> parts = selectedPrinter.split(':');
      String ip = parts[0];
      int port = int.parse(parts[1]);

      // Test the connection
      bool connected =
          await IminD4ThermalPrinter.testPrinterConnection(ip, port);

      if (connected) {
        IminD4ThermalPrinter.configurePrinter(ip, port);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Thermal printer configured: $ip:$port"),
            backgroundColor: greenColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Failed to connect to $ip:$port"),
            backgroundColor: redColor,
          ),
        );
      }
    }
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Scan failed: $e"),
        backgroundColor: redColor,
      ),
    );
  }
}

// Manual printer setup
Future<void> _manualPrinterSetup(BuildContext context) async {
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController =
      TextEditingController(text: '9100');

  bool? configured = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Manual Printer Setup'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ipController,
            decoration: const InputDecoration(
              labelText: 'Printer IP Address',
              hintText: '192.168.1.100',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: portController,
            decoration: const InputDecoration(
              labelText: 'Port',
              hintText: '9100',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            String ip = ipController.text.trim();
            int? port = int.tryParse(portController.text.trim());

            if (ip.isNotEmpty && port != null) {
              Navigator.of(ctx).pop(true);

              // Test connection
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: blueColor),
                      SizedBox(height: 16),
                      Text("Testing connection...",
                          style: TextStyle(color: whiteColor)),
                    ],
                  ),
                ),
              );

              bool connected =
                  await IminD4ThermalPrinter.testPrinterConnection(ip, port);
              Navigator.of(context).pop(); // Close testing dialog

              if (connected) {
                IminD4ThermalPrinter.configurePrinter(ip, port);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("✅ Thermal printer configured: $ip:$port"),
                    backgroundColor: greenColor,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("❌ Failed to connect to $ip:$port"),
                    backgroundColor: redColor,
                  ),
                );
              }
            }
          },
          child: const Text('Test & Save'),
        ),
      ],
    ),
  );
}

// Enhanced print method that can print to both IMIN and thermal printer
Future<void> _printBillWithThermalOption(BuildContext context) async {
  try {
    // Check if thermal printer is configured
    bool thermalConfigured = IminD4ThermalPrinter.isPrinterConfigured;

    if (thermalConfigured) {
      // Show option dialog
      String? printOption = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Select Print Destination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.tablet, color: Colors.blue),
                title: const Text('IMIN Device Only'),
                subtitle: const Text('Print to IMIN D4 internal printer'),
                onTap: () => Navigator.of(ctx).pop('imin'),
              ),
              ListTile(
                leading: const Icon(Icons.print, color: Colors.green),
                title: const Text('Thermal Printer Only'),
                subtitle: Text(
                    'Print to thermal printer (${IminD4ThermalPrinter.printerIP})'),
                onTap: () => Navigator.of(ctx).pop('thermal'),
              ),
              ListTile(
                leading: const Icon(Icons.print_outlined, color: Colors.orange),
                title: const Text('Both Printers'),
                subtitle: const Text('Print to IMIN + Thermal printer'),
                onTap: () => Navigator.of(ctx).pop('both'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      switch (printOption) {
        case 'imin':
          //  await _printBillToImin(context);
          break;
        case 'thermal':
          //   await _printToThermalOnly(context);
          break;
        case 'both':
          //    await _printToBothPrinters(context);
          break;
      }
    } else {
      // No thermal printer configured, show setup option
      bool? setupThermal = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Thermal Printer Not Configured'),
          content: const Text(
              'Would you like to set up thermal printer or print to IMIN only?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('IMIN Only'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Setup Thermal'),
            ),
          ],
        ),
      );

      if (setupThermal == true) {
        await _scanForThermalPrinters(context);
      } else {
        // await _printBillToImin(context);
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Print failed: $e"),
        backgroundColor: redColor,
      ),
    );
  }
}

// Print to thermal printer only
// Future<void> _printToThermalOnly(BuildContext context) async {
//   try {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(color: blueColor),
//             SizedBox(height: 16),
//             Text("Printing to thermal printer...", style: TextStyle(color: whiteColor)),
//           ],
//         ),
//       ),
//     );
//
//     Uint8List? imageBytes = await captureMonochromeReceipt(normalReceiptKey);
//
//     if (imageBytes != null) {
//       bool success = await IminD4ThermalPrinter.printToThermalPrinter(imageBytes);
//
//       Navigator.of(context).pop();
//
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("✅ Printed to thermal printer successfully!"),
//             backgroundColor: greenColor,
//           ),
//         );
//       } else {
//         throw Exception("Thermal printer communication failed");
//       }
//     } else {
//       throw Exception("Failed to capture receipt image");
//     }
//   } catch (e) {
//     Navigator.of(context).pop();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Thermal print failed: $e"),
//         backgroundColor: redColor,
//       ),
//     );
//   }
// }

// Print to both printers
// Future<void> _printToBothPrinters(BuildContext context) async {
//   try {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(color: blueColor),
//             SizedBox(height: 16),
//             Text("Printing to both printers...", style: TextStyle(color: whiteColor)),
//           ],
//         ),
//       ),
//     );
//
//     Uint8List? imageBytes = await captureMonochromeReceipt(normalReceiptKey);
//
//     if (imageBytes != null) {
//       // Print to IMIN first
//       await printerService!.init();
//       await printerService!.printBitmap(imageBytes);
//       await printerService!.fullCut();
//
//       // Then print to thermal printer
//       bool thermalSuccess = await IminD4ThermalPrinter.printToThermalPrinter(imageBytes);
//
//       Navigator.of(context).pop();
//
//       String message = thermalSuccess
//           ? "✅ Printed to both IMIN and thermal printer!"
//           : "⚠️ IMIN printed, thermal printer failed";
//       Color color = thermalSuccess ? greenColor : Colors.orange;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: color),
//       );
//     } else {
//       throw Exception("Failed to capture receipt image");
//     }
//   } catch (e) {
//     Navigator.of(context).pop();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Print failed: $e"),
//         backgroundColor: redColor,
//       ),
//     );
//   }
// }
//
// // Update your buttons in the build method:
// Row(
// children: [
// // Scan for thermal printers button
// ElevatedButton.icon(
// onPressed: () async {
// await _scanForThermalPrinters(context);
// },
// icon: const Icon(Icons.search),
// label: const Text("Find Printer"),
// style: ElevatedButton.styleFrom(
// backgroundColor: blueColor,
// foregroundColor: whiteColor,
// ),
// ),
// horizontalSpace(width: 10),
//
// // Smart print button with thermal option
// ElevatedButton.icon(
// onPressed: () async {
// await _printBillWithThermalOption(context);
// },
// icon: const Icon(Icons.print),
// label: const Text("Smart Print"),
// style: ElevatedButton.styleFrom(
// backgroundColor: greenColor,
// foregroundColor: whiteColor,
// ),
// ),
// ],
// )
