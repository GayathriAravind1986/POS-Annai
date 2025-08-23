import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple/Alertbox/snackBarAlert.dart';
import 'package:simple/Bloc/Report/report_bloc.dart';
import 'package:simple/ModelClass/Report/Get_report_model.dart';
import 'package:simple/ModelClass/Table/Get_table_model.dart';
import 'package:simple/ModelClass/Waiter/getWaiterModel.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Authentication/login_screen.dart';
import 'package:simple/UI/Report/pop_view_report.dart';

class ReportView extends StatelessWidget {
  final GlobalKey<ReportViewViewState>? reportKey;
  bool? hasRefreshedReport;
  ReportView({
    super.key,
    this.reportKey,
    this.hasRefreshedReport,
  });

  @override
  Widget build(BuildContext context) {
    return ReportViewView(
        reportKey: reportKey, hasRefreshedReport: hasRefreshedReport);
  }
}

class ReportViewView extends StatefulWidget {
  final GlobalKey<ReportViewViewState>? reportKey;
  bool? hasRefreshedReport;
  ReportViewView({
    super.key,
    this.reportKey,
    this.hasRefreshedReport,
  });

  @override
  ReportViewViewState createState() => ReportViewViewState();
}

class ReportViewViewState extends State<ReportViewView> {
  GetReportModel getReportModel = GetReportModel();
  GetTableModel getTableModel = GetTableModel();
  GetWaiterModel getWaiterModel = GetWaiterModel();
  dynamic selectedValue;
  dynamic selectedValueWaiter;
  dynamic tableId;
  dynamic waiterId;
  bool tableLoad = false;
  String? errorMessage;
  bool reportLoad = false;
  final String todayDisplayDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now()); // UI
  final String todayApiDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); // API
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  bool includeProduct = true;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? _fromDate;
  DateTime? _toDate;
  final DateTime now = DateTime.now();
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isFromDate ? (_fromDate ?? now) : (_toDate ?? (_fromDate ?? now)),
      firstDate: isFromDate ? DateTime(2000) : (_fromDate ?? DateTime(2000)),
      lastDate: isFromDate ? (_toDate ?? now) : now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appPrimaryColor,
              onPrimary: whiteColor,
              onSurface: blackColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appPrimaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          fromDateController.text = DateFormat('dd/MM/yyyy').format(_fromDate!);
          if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
            _toDate = null;
            toDateController.clear();
          }
        } else {
          _toDate = picked;
          toDateController.text = DateFormat('dd/MM/yyyy').format(_toDate!);
        }
        if (_fromDate != null && _toDate != null) {
          String formattedFromDate =
              DateFormat('yyyy-MM-dd').format(_fromDate!);
          String formattedToDate = DateFormat('yyyy-MM-dd').format(_toDate!);

          context.read<ReportTodayBloc>().add(
                ReportTodayList(formattedFromDate, formattedToDate,
                    tableId ?? "", waiterId ?? ""),
              );
        } else if (_fromDate != null && _toDate == null) {
          String formattedFromDate =
              DateFormat('yyyy-MM-dd').format(_fromDate!);
          String formattedToDate = DateFormat('yyyy-MM-dd').format(now);

          context.read<ReportTodayBloc>().add(
                ReportTodayList(formattedFromDate, formattedToDate,
                    tableId ?? "", waiterId ?? ""),
              );
        }
      });
    }
  }

  void refreshReport() {
    if (!mounted || !context.mounted) return;
    context.read<ReportTodayBloc>().add(
          ReportTodayList(
              todayApiDate, todayApiDate, tableId ?? "", waiterId ?? ""),
        );
    setState(() {
      reportLoad = true;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ReportTodayBloc>().add(TableDine());
    context.read<ReportTodayBloc>().add(WaiterDine());
    if (widget.hasRefreshedReport == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          reportLoad = true;
          fromDateController.text = todayDisplayDate;
          toDateController.text = todayDisplayDate;
        });
        widget.reportKey?.currentState?.refreshReport();
      });
    } else {
      setState(() {
        reportLoad = true;
        fromDateController.text = todayDisplayDate;
        toDateController.text = todayDisplayDate;
      });
      context.read<ReportTodayBloc>().add(
            ReportTodayList(
                todayApiDate, todayApiDate, tableId ?? "", waiterId ?? ""),
          );
    }
  }

  void _refreshData() {
    setState(() {
      selectedValue = null;
      selectedValueWaiter = null;
      tableId = null;
      waiterId = null;
    });
    context.read<ReportTodayBloc>().add(
          ReportTodayList(
              todayApiDate, todayApiDate, tableId ?? "", waiterId ?? ""),
        );
    context.read<ReportTodayBloc>().add(TableDine());
    context.read<ReportTodayBloc>().add(WaiterDine());
    widget.reportKey?.currentState?.refreshReport();
  }

  @override
  void dispose() {
    super.dispose();
    fromDateController.clear;
    toDateController.clear;
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Report",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () {
                        _refreshData();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: appPrimaryColor,
                        size: 28,
                      ),
                      tooltip: 'Refresh Orders',
                    ),
                  ],
                ),
              ),
              verticalSpace(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: const TextSelectionThemeData(
                          selectionColor: Colors.transparent,
                          selectionHandleColor: Colors.transparent,
                        ),
                      ),
                      child: TextField(
                        controller: fromDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'From Date',
                          labelStyle: TextStyle(color: greyColor),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: appPrimaryColor, width: 2),
                          ),
                          suffixIcon: fromDateController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      fromDateController.clear();
                                      _fromDate = null;
                                      if (fromDateController.text.isEmpty &&
                                          toDateController.text.isEmpty) {
                                        context.read<ReportTodayBloc>().add(
                                              ReportTodayList(
                                                  todayApiDate,
                                                  todayApiDate,
                                                  tableId ?? "",
                                                  waiterId ?? ""),
                                            );
                                      }
                                    });
                                  },
                                )
                              : null,
                        ),
                        onTap: () => _selectDate(context, true),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: const TextSelectionThemeData(
                          selectionColor: Colors.transparent,
                          selectionHandleColor: Colors.transparent,
                        ),
                      ),
                      child: TextField(
                        controller: toDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'To Date',
                          labelStyle: TextStyle(color: greyColor),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: appPrimaryColor, width: 2),
                          ),
                          suffixIcon: toDateController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      toDateController.clear();
                                      _toDate = null;
                                      if (fromDateController.text.isEmpty &&
                                          toDateController.text.isEmpty) {
                                        context.read<ReportTodayBloc>().add(
                                              ReportTodayList(
                                                  todayApiDate,
                                                  todayApiDate,
                                                  tableId ?? "",
                                                  waiterId ?? ""),
                                            );
                                      }
                                    });
                                  },
                                )
                              : null,
                        ),
                        onTap: () => _selectDate(context, false),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: DropdownButtonFormField<String>(
                        value: (getTableModel.data?.any(
                                    (item) => item.name == selectedValue) ??
                                false)
                            ? selectedValue
                            : null,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: appPrimaryColor,
                        ),
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: appPrimaryColor,
                            ),
                          ),
                        ),
                        items: getTableModel.data?.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.name,
                            child: Text(
                              "Table ${item.name}",
                              style: MyTextStyle.f14(
                                blackColor,
                                weight: FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedValue = newValue;
                              final selectedItem = getTableModel.data
                                  ?.firstWhere((item) => item.name == newValue);
                              tableId = selectedItem?.id.toString();
                              context.read<ReportTodayBloc>().add(
                                    ReportTodayList(todayApiDate, todayApiDate,
                                        tableId ?? "", waiterId ?? ""),
                                  );
                            });
                          }
                        },
                        hint: Text(
                          '-- Select Table --',
                          style: MyTextStyle.f14(
                            blackColor,
                            weight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: DropdownButtonFormField<String>(
                        value: (getWaiterModel.data?.any((item) =>
                                    item.name == selectedValueWaiter) ??
                                false)
                            ? selectedValueWaiter
                            : null,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: appPrimaryColor,
                        ),
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: appPrimaryColor,
                            ),
                          ),
                        ),
                        items: getWaiterModel.data?.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.name,
                            child: Text(
                              "${item.name}",
                              style: MyTextStyle.f14(
                                blackColor,
                                weight: FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedValueWaiter = newValue;
                              final selectedItem = getWaiterModel.data
                                  ?.firstWhere((item) => item.name == newValue);
                              waiterId = selectedItem?.id.toString();
                              context.read<ReportTodayBloc>().add(
                                    ReportTodayList(todayApiDate, todayApiDate,
                                        tableId ?? "", waiterId ?? ""),
                                  );
                            });
                          }
                        },
                        hint: Text(
                          '-- Select Waiter --',
                          style: MyTextStyle.f14(
                            blackColor,
                            weight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: includeProduct,
                    activeColor: appPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        includeProduct = value ?? true;
                      });
                    },
                  ),
                  const Text("Include product"),
                ],
              ),
              SizedBox(height: 24),
              reportLoad
                  ? Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      alignment: Alignment.center,
                      child: const SpinKitChasingDots(
                          color: appPrimaryColor, size: 30))
                  : getReportModel.data == null ||
                          getReportModel.data == [] ||
                          getReportModel.data!.isEmpty
                      ? Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.3),
                          alignment: Alignment.center,
                          child: Text(
                            "No Report found !!!",
                            style: MyTextStyle.f16(
                              greyColor,
                              weight: FontWeight.w500,
                            ),
                          ))
                      : Column(
                          children: [
                            if (includeProduct) ...[
                              Table(
                                border: TableBorder.all(),
                                columnWidths: const {
                                  0: FixedColumnWidth(50),
                                  1: FlexColumnWidth(),
                                  2: FixedColumnWidth(75),
                                  3: FixedColumnWidth(80),
                                },
                                children: [
                                  const TableRow(
                                    decoration:
                                        BoxDecoration(color: appPrimaryColor),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("S.No",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Product Name",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Quantity",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Amount",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ...List.generate(getReportModel.data!.length,
                                      (index) {
                                    final item = getReportModel.data![index];
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                              child: Text("${index + 1}")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(item.productName ?? ""),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                              child: Text(
                                                  "${item.totalQty ?? ""}")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                              child: Text(item.totalAmount
                                                      ?.toStringAsFixed(2) ??
                                                  "")),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],

                            // ✅ Always show totals
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Quantity: ${getReportModel.finalQty}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "Total Amount: ₹${getReportModel.finalAmount?.toStringAsFixed(2) ?? '0.00'}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ThermalReportReceiptDialog(
                                            getReportModel,
                                            showItems: includeProduct),
                                  );
                                },
                                icon: const Icon(Icons.print),
                                label: const Text("Print"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: greenColor,
                                  foregroundColor: whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<ReportTodayBloc, dynamic>(
      buildWhen: ((previous, current) {
        if (current is GetReportModel) {
          try {
            getReportModel = current;
            if (getReportModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            if (getReportModel.success == true) {
              setState(() {
                reportLoad = false;
              });
            } else {
              setState(() {
                reportLoad = false;
              });
            }
          } catch (e, stackTrace) {
            debugPrint("Error in processing report order: $e");
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
        if (current is GetTableModel) {
          getTableModel = current;
          if (getTableModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          if (getTableModel.success == true) {
            setState(() {
              tableLoad = false;
            });
          } else {
            setState(() {
              tableLoad = false;
            });
            showToast("No Tables found", context, color: false);
          }
          return true;
        }
        if (current is GetWaiterModel) {
          getWaiterModel = current;
          if (getWaiterModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          if (getWaiterModel.success == true) {
            setState(() {
              tableLoad = false;
            });
          } else {
            setState(() {
              tableLoad = false;
            });
            showToast("No Waiter found", context, color: false);
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
    await sharedPreferences.remove("token");
    await sharedPreferences.clear();
    showToast("Session expired. Please login again.", context, color: false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
