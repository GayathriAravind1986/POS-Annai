import 'dart:io';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:simple/ModelClass/Order/Get_view_order_model.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/imin_abstract.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/mock_imin_printer_chrome.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/real_device_printer.dart';
import 'package:simple/UI/IminHelper/printer_helper.dart';
import 'package:simple/UI/KOT_printer_helper/printer_kot_helper.dart';

class ThermalReceiptDialog extends StatefulWidget {
  final GetViewOrderModel getViewOrderModel;

  const ThermalReceiptDialog(this.getViewOrderModel, {super.key});

  @override
  State<ThermalReceiptDialog> createState() => _ThermalReceiptDialogState();
}

class _ThermalReceiptDialogState extends State<ThermalReceiptDialog> {
  late IPrinterService printerService;
  late IPrinterService printerServiceThermal;
  GlobalKey normalReceiptKey = GlobalKey();
  GlobalKey kotReceiptKey = GlobalKey();

  List<BluetoothInfo> _devices = [];
  bool _isScanning = false;

  final TextEditingController ipController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // ipController.text = "192.168.1.123";
    if (kIsWeb) {
      printerService = MockPrinterService();
      printerServiceThermal = MockPrinterService();
    } else if (Platform.isAndroid) {
      printerService = RealPrinterService();
      printerServiceThermal = RealPrinterService();
    } else {
      printerService = MockPrinterService();
      printerServiceThermal = MockPrinterService();
    }
  }

  Future<void> _ensureIminServiceReady() async {
    try {
      await printerService.init();
    } catch (e) {
      debugPrint("Error reinitializing IMIN service: $e");
    }
  }

  Future<void> _showPrinterIpDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Thermal Printer Setup"),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: "Thermal Printer IP Address",
                hintText: "e.g. 192.168.1.96",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter printer IP";
                }
                final regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                if (!regex.hasMatch(value.trim())) {
                  return "Enter valid IP (e.g. 192.168.1.96)";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel",
                  style: TextStyle(color: appPrimaryColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx);
                  if (ipController.text.isNotEmpty) {
                    _startKOTPrintingThermalOnly(
                      context,
                      ipController.text.trim(),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter Thermal Printer IP!"),
                        backgroundColor: redColor,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                "Connect & Print KOT",
                style: TextStyle(color: appPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scanBluetoothDevices() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    try {
      // Check if Bluetooth is enabled
      final bool result = await PrintBluetoothThermal.bluetoothEnabled;
      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bluetooth is not enabled"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isScanning = false);
        return;
      }

      // Get paired Bluetooth devices
      final List<BluetoothInfo> bluetooths =
          await PrintBluetoothThermal.pairedBluetooths;
      setState(() {
        _devices = bluetooths;
        _isScanning = false;
      });
    } catch (e) {
      debugPrint("Error scanning Bluetooth devices: $e");
      setState(() => _isScanning = false);
    }
  }

  Future<void> _selectBluetoothPrinter(BuildContext context) async {
    await _scanBluetoothDevices();

    if (_devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "No paired Bluetooth printers found. Please pair your printer first."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select Bluetooth Printer",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _devices.length,
                itemBuilder: (_, index) {
                  final printer = _devices[index];
                  return ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(
                        printer.name), // Changed from printer.name ?? "Unknown"
                    subtitle: Text(printer
                        .macAdress), // Changed from printer.address ?? ""
                    onTap: () {
                      Navigator.pop(context);
                      _startKOTPrintingBluetoothOnly(context, printer);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// BT KOT Print
  Future<void> _startKOTPrintingBluetoothOnly(
      BuildContext context, BluetoothInfo printer) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: appPrimaryColor),
              SizedBox(height: 16),
              Text("Preparing KOT for Bluetooth printer...",
                  style: TextStyle(color: whiteColor)),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      await WidgetsBinding.instance.endOfFrame;

      Uint8List? imageBytes = await captureMonochromeKOTReceipt(kotReceiptKey);

      if (imageBytes != null) {
        final bool connectionResult = await PrintBluetoothThermal.connect(
            macPrinterAddress: printer.macAdress);

        if (!connectionResult) {
          throw Exception("Failed to connect to printer");
        }

        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm58, profile);

        final decodedImage = img.decodeImage(imageBytes);
        if (decodedImage != null) {
          // Updated API for image package v4.x
          final resizedImage = img.copyResize(
            decodedImage,
            width: 384,
            maintainAspect: true,
          );

          List<int> bytes = [];
          bytes += generator.reset();

          // For image v4.x, the imageRaster method signature may be different
          // Check the documentation, but this should work:
          bytes += generator.imageRaster(resizedImage);

          bytes += generator.feed(2);
          bytes += generator.cut();

          final bool printResult =
              await PrintBluetoothThermal.writeBytes(bytes);
          await PrintBluetoothThermal.disconnect;

          Navigator.of(context).pop();

          if (printResult) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("KOT printed to Bluetooth printer!"),
                backgroundColor: greenColor,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to send data to printer"),
                backgroundColor: redColor,
              ),
            );
          }
        }
      } else {
        Navigator.of(context).pop();
        throw Exception("Failed to capture KOT receipt image");
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("KOT Print failed: $e"),
          backgroundColor: redColor,
        ),
      );
    }
  }

  /// LAN KOT Print
  Future<void> _startKOTPrintingThermalOnly(
      BuildContext context, String printerIp) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: appPrimaryColor),
              SizedBox(height: 16),
              Text("Preparing KOT for thermal printer...",
                  style: TextStyle(color: whiteColor)),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      await WidgetsBinding.instance.endOfFrame;

      Uint8List? imageBytes = await captureMonochromeKOTReceipt(kotReceiptKey);

      if (imageBytes != null) {
        final printer = PrinterNetworkManager(printerIp);
        final result = await printer.connect();

        if (result == PosPrintResult.success) {
          final profile = await CapabilityProfile.load();
          final generator = Generator(PaperSize.mm58, profile);

          final decodedImage = img.decodeImage(imageBytes);
          if (decodedImage != null) {
            final resizedImage = img.copyResize(
              decodedImage,
              width: 384, // 58mm = ~384 dots at 203 DPI
              maintainAspect: true,
            );
            List<int> bytes = [];
            bytes += generator.reset();
            bytes += generator.imageRaster(
              resizedImage,
              align: PosAlign.center,
              highDensityHorizontal: true, // Better quality
              highDensityVertical: true,
            );
            bytes += generator.feed(2);
            bytes += generator.cut();
            await printer.printTicket(bytes);
          }

          await printer.disconnect();

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("KOT printed to thermal printer only!"),
              backgroundColor: greenColor,
            ),
          );
        } else {
          // ❌ Failed to connect
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to connect to printer ($result)"),
              backgroundColor: redColor,
            ),
          );
        }
      } else {
        Navigator.of(context).pop();
        throw Exception("Failed to capture KOT receipt image");
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("KOT Print failed: $e"),
          backgroundColor: redColor,
        ),
      );
    }
  }

  Future<void> _printBillToIminOnly(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: appPrimaryColor,
              ),
              SizedBox(height: 16),
              Text("Printing to IMIN device...",
                  style: TextStyle(color: whiteColor)),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      await WidgetsBinding.instance.endOfFrame;

      Uint8List? imageBytes = await captureMonochromeReceipt(normalReceiptKey);

      if (imageBytes != null) {
        await printerService.init();
        await printerService.printBitmap(imageBytes);
        await printerService.fullCut();

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bill printed successfully to IMIN device!"),
            backgroundColor: greenColor,
          ),
        );
      } else {
        throw Exception("Image capture failed: normalReceiptKey returned null");
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("IMIN Print failed: $e"),
          backgroundColor: redColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.getViewOrderModel.data!;
    final invoice = order.invoice!;
    var size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> items = order.items!
        .map((e) => {
              'name': e.name,
              'qty': e.quantity,
              'price': (e.unitPrice ?? 0).toDouble(),
              'total': ((e.quantity ?? 0) * (e.unitPrice ?? 0)).toDouble(),
            })
        .toList();
    List<Map<String, dynamic>> kotItems = invoice.kotItems!
        .map((e) => {
              'name': e.name,
              'qty': e.quantity,
            })
        .toList();
    List<Map<String, dynamic>> finalTax = order.finalTaxes!
        .map((e) => {
              'name': e.name,
              'amt': e.amount,
            })
        .toList();
    String businessName = invoice.businessName ?? '';
    String address = invoice.address ?? '';
    String gst = invoice.gstNumber ?? '';
    double taxAmount = (order.tax ?? 0.0).toDouble();
    String orderNumber = order.orderNumber ?? 'N/A';
    String paymentMethod = invoice.paidBy ?? '';
    String phone = invoice.phone ?? '';
    double subTotal = (invoice.subtotal ?? 0.0).toDouble();
    double total = (invoice.total ?? 0.0).toDouble();
    String orderType = order.orderType ?? '';
    String orderStatus = order.orderStatus ?? '';
    String tableName = orderType == 'LINE' || orderType == 'AC'
        ? (invoice.tableNum ?? 'N/A')
        : 'N/A';
    String waiterName = orderType == 'LINE' || orderType == 'AC'
        ? (invoice.waiterNum ?? 'N/A')
        : 'N/A';
    String date = DateFormat('dd/MM/yyyy hh:mm a').format(
        DateFormat('M/d/yyyy, h:mm:ss a').parse(invoice.date.toString()));
    ipController.text = invoice.thermalIp.toString() ?? "";
    debugPrint("ip:${ipController.text}");
    return widget.getViewOrderModel.data == null
        ? Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            alignment: Alignment.center,
            child: Text(
              "No Orders found",
              style: MyTextStyle.f16(
                greyColor,
                weight: FontWeight.w500,
              ),
            ))
        : Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width * 0.4,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: const Text(
                                  "Order Receipt",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RepaintBoundary(
                            key: normalReceiptKey,
                            child: getThermalReceiptWidget(
                              businessName: businessName,
                              address: address,
                              gst: gst,
                              items: items,
                              finalTax: finalTax,
                              tax: taxAmount,
                              paidBy: paymentMethod,
                              tamilTagline: '',
                              phone: phone,
                              subtotal: subTotal,
                              total: total,
                              orderNumber: orderNumber,
                              tableName: tableName,
                              waiterName: waiterName,
                              orderType: orderType,
                              date: date,
                              status: orderStatus,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (invoice.kotItems!.isNotEmpty)
                            RepaintBoundary(
                              key: kotReceiptKey,
                              child: getThermalReceiptKOTWidget(
                                businessName: businessName,
                                address: address,
                                gst: gst,
                                items: kotItems,
                                paidBy: paymentMethod,
                                tamilTagline: '',
                                phone: phone,
                                subtotal: subTotal,
                                tax: taxAmount,
                                total: total,
                                orderNumber: orderNumber,
                                tableName: tableName,
                                waiterName: waiterName,
                                orderType: orderType,
                                date: date,
                                status: orderStatus,
                              ),
                            ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (invoice.kotItems!.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () {
                            _startKOTPrintingThermalOnly(
                              context,
                              ipController.text.trim(),
                            );
                          },
                          icon: const Icon(Icons.print),
                          label: const Text("KOT(LAN)"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            foregroundColor: whiteColor,
                          ),
                        ),
                      horizontalSpace(width: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await _ensureIminServiceReady();
                            await _printBillToIminOnly(context);
                          });
                        },
                        icon: const Icon(Icons.print),
                        label: const Text("Imin"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          foregroundColor: whiteColor,
                        ),
                      ),
                      horizontalSpace(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: const Text("CLOSE"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor,
                          foregroundColor: whiteColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
