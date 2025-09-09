import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple/ModelClass/Products/get_products_cat_model.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/imin_abstract.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/mock_imin_printer_chrome.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/real_device_printer.dart';
import 'package:simple/UI/IminHelper/product_helper.dart';

class ThermalProductsReceiptDialog extends StatefulWidget {
  final GetProductsCatModel getProductsCatModel;
  const ThermalProductsReceiptDialog(
    this.getProductsCatModel, {
    super.key,
  });

  @override
  State<ThermalProductsReceiptDialog> createState() =>
      _ThermalProductsReceiptDialogState();
}

class _ThermalProductsReceiptDialogState
    extends State<ThermalProductsReceiptDialog> {
  late IPrinterService printerService;
  final GlobalKey productKey = GlobalKey();

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
    final allCategories = widget.getProductsCatModel.data!.categories ?? [];

    List<Map<String, dynamic>> itemsLine = allCategories
        .expand((cat) => cat.products!.map((p) => {
              "id": p.id,
              "name": p.name,
              "code": p.shortCode,
              "price": p.basePrice,
              "parcel": p.parcelPrice,
              "ac": p.acPrice,
              "hd": p.hdPrice,
              "categoryName": cat.categoryName,
            }))
        .toList();
    String businessName = widget.getProductsCatModel.data!.businessName ?? '';
    String address = widget.getProductsCatModel.data!.address ?? '';
    String gst = widget.getProductsCatModel.data!.gstNumber ?? '';
    String phone = widget.getProductsCatModel.data!.phone ?? '';
    String totalCat =
        widget.getProductsCatModel.data!.totalCategories.toString() ?? '';
    String totalCount =
        widget.getProductsCatModel.data!.totalProducts.toString() ?? '';
    String date = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

    return
        // widget.getProductsCatModel.data! == null
        //   ? Container(
        //       padding:
        //           EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        //       alignment: Alignment.center,
        //       child: Text(
        //         "No Report found",
        //         style: MyTextStyle.f16(
        //           greyColor,
        //           weight: FontWeight.w500,
        //         ),
        //       ))
        //   :
        Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                      "Products Report (Category-wise)",
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
                key: productKey,
                child: getProductReceiptWidget(
                    businessName: businessName,
                    tamilTagline: "",
                    address: address,
                    gst: gst,
                    phone: phone,
                    itemsLine: itemsLine,
                    reportDate: date,
                    totalCat: totalCat,
                    totalCount: totalCount),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await Future.delayed(const Duration(milliseconds: 300));
                        await WidgetsBinding.instance.endOfFrame;
                        Uint8List? imageBytes =
                            await captureMonochromeProducts(productKey);

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
