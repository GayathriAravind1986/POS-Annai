import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:simple/ModelClass/Order/Get_view_order_model.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/imin_abstract.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/mock_imin_printer_chrome.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/real_device_printer.dart';
import 'package:simple/UI/IminHelper/printer_helper.dart';

class ThermalReceiptDialog extends StatefulWidget {
  final GetViewOrderModel getViewOrderModel;

  const ThermalReceiptDialog(this.getViewOrderModel, {super.key});

  @override
  State<ThermalReceiptDialog> createState() => _ThermalReceiptDialogState();
}

class _ThermalReceiptDialogState extends State<ThermalReceiptDialog> {
  late IPrinterService printerService;
  final GlobalKey receiptKey = GlobalKey();
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

    String businessName = invoice.businessName ?? '';
    String address = invoice.address ?? '';
    String gst = invoice.gstNumber ?? '';
    debugPrint("gst:$gst");
    double taxAmount = (order.tax ?? 0.0).toDouble();
    String orderNumber = order.orderNumber ?? 'N/A';
    String paymentMethod = invoice.paidBy ?? '';
    String phone = invoice.phone ?? '';
    double subTotal = (invoice.subtotal ?? 0.0).toDouble();
    double total = (invoice.total ?? 0.0).toDouble();
    String orderType = order.orderType ?? '';
    String orderStatus = order.orderStatus ?? '';
    String tableName =
        orderType == 'DINE-IN' ? (invoice.tableNum ?? 'N/A') : 'N/A';
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
                      key: receiptKey,
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
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              await WidgetsBinding.instance.endOfFrame;
                              Uint8List? imageBytes =
                                  await captureMonochromeReceipt(receiptKey);

                              if (imageBytes != null) {
                                await printerService.init();
                                await printerService.printBitmap(imageBytes);
                                // await Future.delayed(
                                //     const Duration(seconds: 2));
                                await printerService.fullCut();
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Print failed: $e")),
                              );
                            }
                          },
                          icon: const Icon(Icons.print),
                          label: const Text("Print"),
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
