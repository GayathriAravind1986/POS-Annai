import 'dart:io';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:simple/ModelClass/Order/Get_view_order_model.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Device_Helper/device_helper.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/imin_abstract.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/mock_imin_printer_chrome.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/real_device_printer.dart';
import 'package:simple/UI/IminHelper/printer_helper.dart';
import 'package:simple/UI/KOT_printer_helper/printer_kot_helper.dart';
import 'package:image/image.dart' as img;

class ThermalReceiptDialog extends StatefulWidget {
  final GetViewOrderModel getViewOrderModel;

  const ThermalReceiptDialog(this.getViewOrderModel, {super.key});

  @override
  State<ThermalReceiptDialog> createState() => _ThermalReceiptDialogState();
}

class _ThermalReceiptDialogState extends State<ThermalReceiptDialog> {
  IPrinterService? printerService;
  IPrinterService? printerServiceThermal;
  GlobalKey normalReceiptKey = GlobalKey();
  GlobalKey kotReceiptKey = GlobalKey();
  final TextEditingController ipController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? portIp;
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      printerService = MockPrinterService();
    } else if (Platform.isAndroid) {
      printerService = RealPrinterService();
    } else {
      printerService = MockPrinterService();
    }
  }

  Future<String?> getSubnet() async {
    final info = NetworkInfo();
    String? ip = await info.getWifiIP();
    if (ip == null) return null;

    final parts = ip.split('.');
    if (parts.length != 4) return null;
    return "${parts[0]}.${parts[1]}.${parts[2]}";
  }

  Future<void> discoverPrintersWithPorts(BuildContext context) async {
    String? subnet = await getSubnet();
    if (subnet == null) {
      print("❌ No WiFi connection or invalid IP.");
      return;
    }

    List<int> portsToCheck = [9100, 9101, 9102, 631, 515];

    for (int i = 1; i < 255; i++) {
      String ip = "$subnet.$i";
      for (int port in portsToCheck) {
        try {
          final socket = await Socket.connect(ip, port,
              timeout: const Duration(milliseconds: 200));

          print("✅ Printer found at $ip:$port");
          ipController.text = ip;
          portIp = port.toString();

          socket.destroy();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Printer Status'),
              content: Text("Printer auto-detected at $ip:$port"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _startKOTPrintingThermalOnly(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        } catch (_) {
          // not a printer, skip
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No thermal printer found in network"),
        backgroundColor: redColor,
      ),
    );
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
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx);
                  await _startKOTPrintingThermalOnly(context);
                }
              },
              child: const Text("Connect & Print KOT"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _printBillToImin(BuildContext context) async {
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
              Text("Preparing IMIN printer...",
                  style: TextStyle(color: whiteColor)),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      await WidgetsBinding.instance.endOfFrame;

      Uint8List? imageBytes = await captureMonochromeReceipt(normalReceiptKey);

      if (imageBytes != null) {
        await printerService!.init();
        await printerService!.printBitmap(imageBytes);
        await printerService!.fullCut();

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bill printed successfully to IMIN device!"),
            backgroundColor: greenColor,
          ),
        );
      } else {
        throw Exception("Image capture failed");
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

  Future<void> _startKOTPrintingThermalOnly(BuildContext context) async {
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
        await printerServiceThermal!.init();
        await printerServiceThermal!.printBitmap(imageBytes);
        await printerServiceThermal!.fullCut();
        // final printer = PrinterNetworkManager(printerIp);
        // final result = await printer.connect();
        //
        // if (result == PosPrintResult.success) {
        //   // ✅ Connected
        //   final profile = await CapabilityProfile.load();
        //   final generator = Generator(PaperSize.mm58, profile);
        //
        //   final decodedImage = img.decodeImage(imageBytes);
        //   if (decodedImage != null) {
        //     List<int> bytes = [];
        //     bytes += generator.reset();
        //     bytes +=
        //         generator.imageRaster(decodedImage, align: PosAlign.center);
        //     bytes += generator.feed(2);
        //     bytes += generator.cut();
        //     await printer.printTicket(bytes);
        //   }
        //
        //   await printer.disconnect();

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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Failed to connect to printer ($result)"),
        //     backgroundColor: redColor,
        //   ),
        // );
        //}
      }
      // else {
      //   Navigator.of(context).pop();
      //   throw Exception("Failed to capture KOT receipt image");
      // }
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
            child: SingleChildScrollView(
              child: Container(
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

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     discoverPrintersWithPorts(context);
                        //   },
                        //   icon: const Icon(Icons.info_outline),
                        //   label: const Text("Printer Detect"),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.blue,
                        //     foregroundColor: whiteColor,
                        //   ),
                        // ),
                        // horizontalSpace(width: 10),
                        if (invoice.kotItems!.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: () {
                              discoverPrintersWithPorts(context);
                            },
                            icon: const Icon(Icons.print),
                            label: const Text("KOT Print"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor,
                              foregroundColor: whiteColor,
                            ),
                          ),
                        horizontalSpace(width: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _printBillToImin(context);
                          },
                          icon: const Icon(Icons.print),
                          label: const Text("Print Bills"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            foregroundColor: whiteColor,
                          ),
                        ),
                        horizontalSpace(width: 10),
                        SizedBox(
                          width: size.width * 0.09,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "CLOSE",
                              style: TextStyle(color: appPrimaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Close Button
                  ],
                ),
              ),
            ),
          );
  }
}
