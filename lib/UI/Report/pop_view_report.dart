import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple/ModelClass/Report/Get_report_with_ordertype_model.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/imin_abstract.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/mock_imin_printer_chrome.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/real_device_printer.dart';
import 'package:simple/UI/IminHelper/Report_helper.dart';

class ThermalReportReceiptDialog extends StatefulWidget {
  final GetReportModel getReportModel;
  final bool showItems;
  const ThermalReportReceiptDialog(this.getReportModel,
      {super.key, required this.showItems});

  @override
  State<ThermalReportReceiptDialog> createState() =>
      _ThermalReportReceiptDialogState();
}

class _ThermalReportReceiptDialogState
    extends State<ThermalReportReceiptDialog> {
  late IPrinterService printerService;
  final GlobalKey reportKey = GlobalKey();

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
    var size = MediaQuery.of(context).size;
    final reportLine = widget.getReportModel.orderTypes!.line!.data!;
    final reportParcel = widget.getReportModel.orderTypes!.parcel!.data!;
    final reportAc = widget.getReportModel.orderTypes!.ac!.data!;
    final reportHd = widget.getReportModel.orderTypes!.hd!.data!;
    final reportSwiggy = widget.getReportModel.orderTypes!.swiggy!.data!;

    List<Map<String, dynamic>> itemsLine = reportLine
        .map((e) => {
              'name': e.productName,
              'qty': e.totalQty,
              'price': (e.unitPrice ?? 0).toDouble(),
              'total': (e.totalAmount ?? 0).toDouble(),
            })
        .toList();
    List<Map<String, dynamic>> itemsParcel = reportParcel
        .map((e) => {
              'name': e.productName,
              'qty': e.totalQty,
              'price': (e.unitPrice ?? 0).toDouble(),
              'total': (e.totalAmount ?? 0).toDouble(),
            })
        .toList();
    List<Map<String, dynamic>> itemsAc = reportAc
        .map((e) => {
              'name': e.productName,
              'qty': e.totalQty,
              'price': (e.unitPrice ?? 0).toDouble(),
              'total': (e.totalAmount ?? 0).toDouble(),
            })
        .toList();
    List<Map<String, dynamic>> itemsHd = reportHd
        .map((e) => {
              'name': e.productName,
              'qty': e.totalQty,
              'price': (e.unitPrice ?? 0).toDouble(),
              'total': (e.totalAmount ?? 0).toDouble(),
            })
        .toList();
    List<Map<String, dynamic>> itemsSwiggy = reportSwiggy
        .map((e) => {
              'name': e.productName,
              'qty': e.totalQty,
              'price': (e.unitPrice ?? 0).toDouble(),
              'total': (e.totalAmount ?? 0).toDouble(),
            })
        .toList();
    String businessName = widget.getReportModel.businessName ?? '';
    String userName = widget.getReportModel.userName ?? '';
    String address = widget.getReportModel.address ?? '';
    String location = widget.getReportModel.location ?? '';
    String tableName = widget.getReportModel.tableName ?? '';
    String waiterName = widget.getReportModel.waiterName ?? '';
    String fromDate = DateFormat('dd/MM/yyyy').format(
      DateTime.parse(widget.getReportModel.fromDate.toString()),
    );

    String toDate = DateFormat('dd/MM/yyyy').format(
      DateTime.parse(widget.getReportModel.toDate.toString()),
    );
    String phone = widget.getReportModel.phone ?? '';
    double lineAmount =
        (widget.getReportModel.orderTypes!.line!.totalAmount ?? 0.0).toDouble();
    int lineQty =
        (widget.getReportModel.orderTypes!.line!.totalQty ?? 0.0).toInt();
    double parcelAmount =
        (widget.getReportModel.orderTypes!.parcel!.totalAmount ?? 0.0)
            .toDouble();
    int parcelQty =
        (widget.getReportModel.orderTypes!.parcel!.totalQty ?? 0.0).toInt();
    double acAmount =
        (widget.getReportModel.orderTypes!.ac!.totalAmount ?? 0.0).toDouble();
    int acQty = (widget.getReportModel.orderTypes!.ac!.totalQty ?? 0.0).toInt();
    double hdAmount =
        (widget.getReportModel.orderTypes!.hd!.totalAmount ?? 0.0).toDouble();
    int hdQty = (widget.getReportModel.orderTypes!.hd!.totalQty ?? 0.0).toInt();
    double swiggyAmount =
        (widget.getReportModel.orderTypes!.swiggy!.totalAmount ?? 0.0)
            .toDouble();
    int swiggyQty =
        (widget.getReportModel.orderTypes!.swiggy!.totalQty ?? 0.0).toInt();
    double totalAmount = (widget.getReportModel.finalAmount ?? 0.0).toDouble();
    int totalQty = (widget.getReportModel.finalQty ?? 0.0).toInt();
    String date = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

    return widget.getReportModel.orderTypes!.line!.data == null ||
            widget.getReportModel.orderTypes!.parcel!.data == null ||
            widget.getReportModel.orderTypes!.ac!.data == null ||
            widget.getReportModel.orderTypes!.hd!.data == null ||
            widget.getReportModel.orderTypes!.swiggy!.data == null
        ? Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            alignment: Alignment.center,
            child: Text(
              "No Report found",
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
                            "Report",
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

                    // Thermal Receipt Widget
                    RepaintBoundary(
                      key: reportKey,
                      child: getReportReceiptWidget(
                          businessName: businessName,
                          tamilTagline: "",
                          address: address,
                          phone: phone,
                          itemsLine: itemsLine,
                          itemsParcel: itemsParcel,
                          itemsAc: itemsAc,
                          itemsHd: itemsHd,
                          itemsSwiggy: itemsSwiggy,
                          reportDate: date,
                          takenBy: userName,
                          tableName: tableName,
                          waiterName: waiterName,
                          lineAmount: lineAmount,
                          lineQty: lineQty,
                          parcelAmount: parcelAmount,
                          parcelQty: parcelQty,
                          acAmount: acAmount,
                          acQty: acQty,
                          hdAmount: hdAmount,
                          hdQty: hdQty,
                          swiggyAmount: swiggyAmount,
                          swiggyQty: swiggyQty,
                          totalQuantity: totalQty,
                          totalAmount: totalAmount,
                          fromDate: fromDate,
                          toDate: toDate,
                          location: location,
                          showItems: widget.showItems),
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
                                  await captureMonochromeReport(reportKey);

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
