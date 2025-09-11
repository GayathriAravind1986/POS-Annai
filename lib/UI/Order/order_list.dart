import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple/Alertbox/snackBarAlert.dart';
import 'package:simple/Bloc/Order/order_list_bloc.dart';
import 'package:simple/ModelClass/Order/Delete_order_model.dart';
import 'package:simple/ModelClass/Order/Get_view_order_model.dart';
import 'package:simple/ModelClass/Order/Update_generate_order_model.dart';
import 'package:simple/ModelClass/Order/get_order_list_today_model.dart';
import 'package:simple/ModelClass/ShopDetails/getStockMaintanencesModel.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Authentication/login_screen.dart';
import 'package:simple/UI/Cart/Widget/payment_option.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/imin_abstract.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/mock_imin_printer_chrome.dart';
import 'package:simple/UI/Home_screen/Widget/another_imin_printer/real_device_printer.dart';
import 'package:simple/UI/IminHelper/printer_helper.dart';
import 'package:simple/UI/Order/Helper/order_helper_waitlist.dart';
import 'package:simple/UI/Order/Helper/time_formatter.dart';
import 'package:simple/UI/Order/pop_view_order.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:image/image.dart' as img;
import 'package:simple/UI/KOT_printer_helper/printer_kot_helper.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class OrderView extends StatelessWidget {
  final GlobalKey<OrderViewViewState>? orderAllKey;
  final String type;
  String? selectedTableName;
  String? selectedWaiterName;
  String? selectOperator;
  String? operatorShared;
  final GetOrderListTodayModel? sharedOrderData;
  final bool isLoading;

  OrderView({
    super.key,
    required this.type,
    this.orderAllKey,
    this.selectedTableName,
    this.selectedWaiterName,
    this.selectOperator,
    this.operatorShared,
    this.sharedOrderData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OrderViewView(
      key: orderAllKey,
      type: type,
      selectedTableName: selectedTableName,
      selectedWaiterName: selectedWaiterName,
      selectOperator: selectOperator,
      operatorShared: operatorShared,
      sharedOrderData: sharedOrderData,
      isLoading: isLoading,
    );
  }
}

class OrderViewView extends StatefulWidget {
  final String type;
  String? selectedTableName;
  String? selectedWaiterName;
  String? selectOperator;
  String? operatorShared;

  final GetOrderListTodayModel? sharedOrderData;
  final bool isLoading;

  OrderViewView({
    super.key,
    required this.type,
    this.selectedTableName,
    this.selectedWaiterName,
    this.selectOperator,
    this.operatorShared,
    this.sharedOrderData,
    this.isLoading = false,
  });

  @override
  OrderViewViewState createState() => OrderViewViewState();
}

class OrderViewViewState extends State<OrderViewView> {
  GetOrderListTodayModel getOrderListTodayModel = GetOrderListTodayModel();
  DeleteOrderModel deleteOrderModel = DeleteOrderModel();
  GetViewOrderModel getViewOrderModel = GetViewOrderModel();
  GetStockMaintanencesModel getStockMaintanencesModel =
      GetStockMaintanencesModel();
  UpdateGenerateOrderModel updateGenerateOrderModel =
      UpdateGenerateOrderModel();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController tipController = TextEditingController();
  String? errorMessage;
  bool view = false;
  bool completeLoad = false;
  final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? fromDate;
  String? type;
  String selectedFullPaymentMethod = "";
  late IPrinterService printerService;
  GlobalKey normalReceiptKey = GlobalKey();
  GlobalKey kotReceiptKey = GlobalKey();

  void refreshOrders() {
    if (!mounted || !context.mounted) return;
    context.read<OrderTodayBloc>().add(
          OrderTodayList(todayDate, todayDate, widget.selectedTableName ?? "",
              widget.selectedWaiterName ?? "", widget.selectOperator ?? ""),
        );
  }

  String formatInvoiceDate(String? dateStr) {
    DateTime dateTime;

    if (dateStr == null) {
      return DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
    }

    try {
      dateTime = DateFormat('M/d/yyyy, h:mm:ss a').parse(dateStr);
    } catch (_) {
      try {
        dateTime = DateTime.parse(dateStr);
      } catch (_) {
        dateTime = DateTime.now();
      }
    }
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }

  Future<void> _ensureIminServiceReady() async {
    try {
      // Try to reinitialize the service to ensure it's pointing to IMIN
      await printerService.init();
    } catch (e) {
      debugPrint("Error reinitializing IMIN service: $e");
    }
  }

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

  Future<void> printUpdateOrderReceipt() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      List<Map<String, dynamic>> items = updateGenerateOrderModel.order!.items!
          .map((e) => {
                'name': e.name,
                'qty': e.quantity,
                'price': (e.unitPrice ?? 0).toDouble(),
                'total': ((e.quantity ?? 0) * (e.unitPrice ?? 0)).toDouble(),
              })
          .toList();
      List<Map<String, dynamic>> kotItems =
          updateGenerateOrderModel.invoice!.kot!
              .map((e) => {
                    'name': e.name,
                    'qty': e.quantity,
                  })
              .toList();
      // double _safeConvertToDouble(dynamic value) {
      //   if (value == null) return 0.0;
      //   if (value is num) return value.toDouble();
      //   if (value is String) return double.tryParse(value) ?? 0.0;
      //   return 0.0;
      // }

      List<Map<String, dynamic>> finalTax =
          updateGenerateOrderModel.invoice!.finalTaxes!
              .map((e) => {
                    'name': e.name,
                    'amt': double.parse(e.amount.toString()),
                  })
              .toList();
      String businessName =
          updateGenerateOrderModel.invoice!.businessName ?? '';
      String address = updateGenerateOrderModel.invoice!.address ?? '';
      String gst = updateGenerateOrderModel.invoice!.gstNumber ?? '';
      double taxPercent =
          (updateGenerateOrderModel.order!.tax ?? 0.0).toDouble();
      String orderNumber = updateGenerateOrderModel.order!.orderNumber ?? 'N/A';
      String paymentMethod = updateGenerateOrderModel.invoice!.paidBy ?? '';
      String phone = updateGenerateOrderModel.invoice!.phone ?? '';
      double subTotal =
          (updateGenerateOrderModel.invoice!.subtotal ?? 0.0).toDouble();
      double total =
          (updateGenerateOrderModel.invoice!.total ?? 0.0).toDouble();
      String orderType = updateGenerateOrderModel.order!.orderType ?? '';
      String orderStatus = updateGenerateOrderModel.invoice!.orderStatus ?? '';
      String tableName = orderType == 'LINE' || orderType == 'AC'
          ? updateGenerateOrderModel.invoice!.tableName.toString()
          : 'N/A';
      String waiterName = orderType == 'LINE' || orderType == 'AC'
          ? updateGenerateOrderModel.invoice!.waiterName.toString()
          : 'N/A';
      String date = formatInvoiceDate(updateGenerateOrderModel.invoice?.date);
      Navigator.of(context).pop();
      await showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  RepaintBoundary(
                    key: normalReceiptKey,
                    child: getThermalReceiptWidget(
                        businessName: businessName,
                        address: address,
                        gst: gst,
                        items: items,
                        finalTax: finalTax,
                        tax: taxPercent,
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
                        status: orderStatus),
                  ),
                  const SizedBox(height: 20),
                  if (updateGenerateOrderModel.invoice!.kot!.isNotEmpty)
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
                        tax: taxPercent,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (updateGenerateOrderModel.invoice!.kot!.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () {
                            _startKOTPrintingThermalOnly(
                              context,
                              ipController.text.trim(),
                            );
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
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await _ensureIminServiceReady();
                            await _printBillToIminOnly(context);
                          });
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
                        width: MediaQuery.of(context).size.width * 0.09,
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
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      if (e is DioException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.message}"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: ${e.toString()}"),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    ipController.text = "192.168.1.4";
    if (kIsWeb) {
      printerService = MockPrinterService();
    } else if (Platform.isAndroid) {
      printerService = RealPrinterService();
    } else {
      printerService = MockPrinterService();
    }
    context.read<OrderTodayBloc>().add(StockDetails());
    if (widget.sharedOrderData != null) {
      getOrderListTodayModel = widget.sharedOrderData!;
    }
  }

  @override
  void didUpdateWidget(OrderViewView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sharedOrderData != null) {
      setState(() {
        getOrderListTodayModel = widget.sharedOrderData!;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? type;
    switch (widget.type) {
      case "Line":
        type = "LINE";
        break;
      case "Parcel":
        type = "PARCEL";
        break;
      case "AC":
        type = "AC";
        break;
      case "HD":
        type = "HD";
        break;
      case "SWIGGY":
        type = "SWIGGY";
        break;
      default:
        type = null;
    }

    final filteredOrders = getOrderListTodayModel.data?.where((order) {
          if (widget.type == "All") return true;
          return order.orderType?.toUpperCase() == type;
        }).toList() ??
        [];

    Widget mainContainer() {
      return widget.isLoading
          ? Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              alignment: Alignment.center,
              child: const SpinKitChasingDots(color: appPrimaryColor, size: 30))
          : getOrderListTodayModel.data == null ||
                  getOrderListTodayModel.data == [] ||
                  getOrderListTodayModel.data!.isEmpty
              ? Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  alignment: Alignment.center,
                  child: Text(
                    "No Orders Today !!!",
                    style: MyTextStyle.f16(
                      greyColor,
                      weight: FontWeight.w500,
                    ),
                  ))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: filteredOrders.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final payment = order.payments?.isNotEmpty == true
                          ? order.payments!.first
                          : null;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 Order ID & Total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Order ID: ${order.orderNumber ?? '--'}",
                                      style: MyTextStyle.f14(appPrimaryColor,
                                          weight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    "₹${order.total?.toStringAsFixed(2) ?? '0.00'}",
                                    style: MyTextStyle.f14(appPrimaryColor,
                                        weight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Time: ${formatTime(order.invoice?.date)}",
                                  ),
                                  Text(
                                    payment?.paymentMethod != null &&
                                            payment!.paymentMethod!.isNotEmpty
                                        ? "Payment: ${payment.paymentMethod}: ₹${payment.amount?.toStringAsFixed(2) ?? '0.00'}"
                                        : "Payment: N/A",
                                    style: MyTextStyle.f12(greyColor),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Type: ${order.orderType ?? '--'}"),
                                  Text(
                                    "Status: ${order.orderStatus}",
                                    style: TextStyle(
                                      color: order.orderStatus == 'COMPLETED'
                                          ? greenColor
                                          : orangeColor,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),
                              Text("Table: ${order.tableName ?? 'N/A'}"),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(Icons.remove_red_eye,
                                            color: appPrimaryColor, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            view = true;
                                          });
                                          context
                                              .read<OrderTodayBloc>()
                                              .add(ViewOrder(order.id));
                                        },
                                      ),
                                      SizedBox(width: 4),
                                      // if ((widget.operatorShared ==
                                      //             widget.selectOperator ||
                                      //         widget.selectOperator == null ||
                                      //         widget.selectOperator == "") &&
                                      //     order.orderStatus != 'COMPLETED')
                                      //   IconButton(
                                      //     padding: EdgeInsets.zero,
                                      //     constraints: BoxConstraints(),
                                      //     icon: Icon(Icons.edit,
                                      //         color: appPrimaryColor, size: 20),
                                      //     onPressed: () {
                                      //       setState(() {
                                      //         view = false;
                                      //       });
                                      //       context
                                      //           .read<OrderTodayBloc>()
                                      //           .add(ViewOrder(order.id));
                                      //     },
                                      //   ),
                                      // SizedBox(width: 4),
                                      // IconButton(
                                      //   padding: EdgeInsets.zero,
                                      //   constraints: BoxConstraints(),
                                      //   icon: Icon(Icons.print_outlined,
                                      //       color: appPrimaryColor, size: 20),
                                      //   onPressed: () {
                                      //     setState(() {
                                      //       view = true;
                                      //     });
                                      //     context
                                      //         .read<OrderTodayBloc>()
                                      //         .add(ViewOrder(order.id));
                                      //   },
                                      // ),
                                      if (order.orderStatus != 'COMPLETED')
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(Icons.check_circle,
                                              color: appPrimaryColor, size: 20),
                                          onPressed: () {
                                            setState(() {
                                              view = false;
                                            });
                                            context
                                                .read<OrderTodayBloc>()
                                                .add(ViewOrder(order.id));
                                          },
                                        ),
                                      SizedBox(width: 4),
                                      if (order.orderStatus != 'COMPLETED')
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          icon: Icon(Icons.delete,
                                              color: appPrimaryColor, size: 20),
                                          onPressed: () {
                                            context
                                                .read<OrderTodayBloc>()
                                                .add(DeleteOrder(order.id));
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
    }

    return BlocBuilder<OrderTodayBloc, dynamic>(
      buildWhen: ((previous, current) {
        if (current is GetOrderListTodayModel) {
          getOrderListTodayModel = current;
          return true;
        }
        if (current is DeleteOrderModel) {
          deleteOrderModel = current;
          if (deleteOrderModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          if (deleteOrderModel.success == true) {
            showToast("${deleteOrderModel.message}", context, color: true);
            context
                .read<OrderTodayBloc>()
                .add(OrderTodayList(todayDate, todayDate, "", "", ""));
          } else {
            showToast("${deleteOrderModel.message}", context, color: false);
          }
          return true;
        }
        if (current is GetViewOrderModel) {
          try {
            getViewOrderModel = current;
            if (getViewOrderModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            if (getViewOrderModel.success == true) {
              if (view == true) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                Future.delayed(Duration(seconds: 1));

                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => ThermalReceiptDialog(getViewOrderModel),
                );
              } else {
                // Navigator.of(context)
                //     .pushAndRemoveUntil(
                //         MaterialPageRoute(
                //             builder: (context) => DashBoardScreen(
                //                   selectTab: 0,
                //                   existingOrder: getViewOrderModel,
                //                   isEditingOrder: true,
                //                 )),
                //         (Route<dynamic> route) => false)
                //     .then((value) {
                //   if (value == true) {
                //     context
                //         .read<OrderTodayBloc>()
                //         .add(OrderTodayList(todayDate, todayDate, "", "", ""));
                //   }
                // });
                showDialog(
                    context: context,
                    builder: (context2) {
                      return BlocProvider(
                          create: (context) => OrderTodayBloc(),
                          child: BlocProvider.value(
                              value: BlocProvider.of<OrderTodayBloc>(context,
                                  listen: false),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    title: const Text("Select Payment Method"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize
                                            .min, // important for dialog
                                        children: [
                                          const SizedBox(height: 12),
                                          Text(
                                            "Payment Method",
                                            style: MyTextStyle.f14(
                                              blackColor,
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Wrap(
                                              spacing: 12,
                                              runSpacing: 12,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedFullPaymentMethod =
                                                          "Cash";
                                                    });
                                                  },
                                                  child: PaymentOption(
                                                    icon: Icons.money,
                                                    label: "Cash",
                                                    selected:
                                                        selectedFullPaymentMethod ==
                                                            "Cash",
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedFullPaymentMethod =
                                                          "Card";
                                                    });
                                                  },
                                                  child: PaymentOption(
                                                    icon: Icons.credit_card,
                                                    label: "Card",
                                                    selected:
                                                        selectedFullPaymentMethod ==
                                                            "Card",
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedFullPaymentMethod =
                                                          "UPI";
                                                    });

                                                    if (getStockMaintanencesModel
                                                                .data?.image !=
                                                            null &&
                                                        getStockMaintanencesModel
                                                            .data!
                                                            .image!
                                                            .isNotEmpty) {
                                                      // show QR inside another dialog
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            title: const Text(
                                                                "Scan to Pay"),
                                                            content: SizedBox(
                                                              width: 250,
                                                              height: 250,
                                                              child:
                                                                  Image.network(
                                                                getStockMaintanencesModel
                                                                    .data!
                                                                    .image!,
                                                                fit: BoxFit
                                                                    .contain,
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    const Text(
                                                                        "Failed to load QR"),
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Close",
                                                                  style: TextStyle(
                                                                      color:
                                                                          appPrimaryColor),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      showToast(
                                                          "QR code not available",
                                                          context,
                                                          color: false);
                                                    }
                                                  },
                                                  child: PaymentOption(
                                                    icon: Icons.qr_code,
                                                    label: "UPI",
                                                    selected:
                                                        selectedFullPaymentMethod ==
                                                            "UPI",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          completeLoad
                                              ? SpinKitCircle(
                                                  color: appPrimaryColor,
                                                  size: 30)
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    if (selectedFullPaymentMethod
                                                            .isEmpty ||
                                                        (selectedFullPaymentMethod != "Cash" &&
                                                            selectedFullPaymentMethod !=
                                                                "Card" &&
                                                            selectedFullPaymentMethod !=
                                                                "UPI")) {
                                                      showToast(
                                                          "Select any one of the payment method",
                                                          context,
                                                          color: false);
                                                      return;
                                                    }
                                                    if (selectedFullPaymentMethod == "Cash" ||
                                                        selectedFullPaymentMethod ==
                                                            "Card" ||
                                                        selectedFullPaymentMethod ==
                                                            "UPI") {
                                                      List<Map<String, dynamic>>
                                                          payments = [];
                                                      payments = [
                                                        {
                                                          "amount":
                                                              (getViewOrderModel
                                                                          .data!
                                                                          .total ??
                                                                      0.0)
                                                                  .toDouble(),
                                                          "balanceAmount": 0,
                                                          "method":
                                                              selectedFullPaymentMethod
                                                                  .toUpperCase(),
                                                        }
                                                      ];
                                                      final orderPayload =
                                                          buildOrderWaitListPayload(
                                                        getViewOrderModel:
                                                            getViewOrderModel,
                                                        tableId:
                                                            getViewOrderModel
                                                                .data!.tableNo,
                                                        waiterId:
                                                            getViewOrderModel
                                                                .data!.waiter,
                                                        orderStatus:
                                                            'COMPLETED',
                                                        orderType:
                                                            getViewOrderModel
                                                                .data!.orderType
                                                                .toString(),
                                                        discountAmount:
                                                            getViewOrderModel
                                                                .data!
                                                                .discountAmount!
                                                                .toStringAsFixed(
                                                                    2),
                                                        isDiscountApplied:
                                                            getViewOrderModel
                                                                        .data!
                                                                        .isDiscountApplied ==
                                                                    true
                                                                ? true
                                                                : false,
                                                        tipAmount:
                                                            tipController.text,
                                                        payments: payments,
                                                      );
                                                      debugPrint(
                                                          "payloadComplete:${jsonEncode(orderPayload)}");
                                                      setState(() {
                                                        completeLoad = true;
                                                      });

                                                      context
                                                          .read<
                                                              OrderTodayBloc>()
                                                          .add(UpdateOrder(
                                                              jsonEncode(
                                                                  orderPayload),
                                                              getViewOrderModel
                                                                  .data!.id));
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        appPrimaryColor,
                                                    minimumSize:
                                                        const Size(0, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Complete Order",
                                                    style: TextStyle(
                                                        color: whiteColor),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              )));
                    });
              }
            }
          } catch (e, stackTrace) {
            debugPrint("Error in processing view order: $e");
            print(stackTrace);
            if (e is DioException) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: ${e.message}"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Something went wrong: ${e.toString()}"),
                ),
              );
            }
          }
          return true;
        }
        if (current is GetStockMaintanencesModel) {
          getStockMaintanencesModel = current;
          if (getStockMaintanencesModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          if (getStockMaintanencesModel.success == true) {
            debugPrint("Sock found");
          } else {
            showToast("No Stock found", context, color: false);
          }
          return true;
        }
        if (current is UpdateGenerateOrderModel) {
          updateGenerateOrderModel = current;
          if (updateGenerateOrderModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          if (updateGenerateOrderModel.errorResponse?.statusCode == 500) {
            showToast(
                updateGenerateOrderModel.errorResponse?.message ??
                    "Server error occurred",
                context,
                color: false);
            setState(() {
              completeLoad = false;
            });
            return true;
          }
          if (updateGenerateOrderModel.errorResponse != null) {
            showToast(
                updateGenerateOrderModel.errorResponse?.message ??
                    "An error occurred",
                context,
                color: false);
            setState(() {
              completeLoad = false;
            });
            return true;
          }
          showToast("${updateGenerateOrderModel.message}", context,
              color: true);
          debugPrint(
              "updateGenerateOrderModel.message:${updateGenerateOrderModel.message}");
          //  bool shouldPrintReceipt = isCompleteOrder;
          setState(() {
            completeLoad = false;
            selectedFullPaymentMethod = "";
          });
          if (updateGenerateOrderModel.message != null) {
            Navigator.pop(context);
            printUpdateOrderReceipt();
            context.read<OrderTodayBloc>().add(
                  OrderTodayList(
                      todayDate,
                      todayDate,
                      widget.selectedTableName ?? "",
                      widget.selectedWaiterName ?? "",
                      widget.selectOperator ?? ""),
                );
            // if (shouldPrintReceipt == true &&
            //     updateGenerateOrderModel.message != null) {
            //   printUpdateOrderReceipt();
          } else {
            debugPrint("Receipt not printed - shouldPrintReceipt is false");
          }
          return true;
        }
        return false;
      }),
      builder: (context, dynamic) {
        return mainContainer();
      },
    );
  }

  void _handle401Error() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await SharedPreferences.getInstance();
    await sharedPreferences.remove("token");
    await sharedPreferences.clear();
    showToast("Session expired. Please login again.", context, color: false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
