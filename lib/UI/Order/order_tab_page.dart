import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple/Alertbox/snackBarAlert.dart';
import 'package:simple/Bloc/Order/order_list_bloc.dart';
import 'package:simple/ModelClass/Table/Get_table_model.dart';
import 'package:simple/ModelClass/Waiter/getWaiterModel.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Authentication/login_screen.dart';
import 'package:simple/UI/Order/order_list.dart';

class OrdersTabbedScreen extends StatelessWidget {
  final VoidCallback? onRefresh;
  final GlobalKey<OrderViewViewState>? orderAllKey;
  const OrdersTabbedScreen({
    super.key,
    this.onRefresh,
    this.orderAllKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderTodayBloc(),
      child: OrderTabViewView(
        onRefresh: onRefresh,
        orderAllKey: orderAllKey,
      ),
    );
  }
}

class OrderTabViewView extends StatefulWidget {
  final VoidCallback? onRefresh;
  final GlobalKey<OrderViewViewState>? orderAllKey;
  const OrderTabViewView({
    super.key,
    this.onRefresh,
    this.orderAllKey,
  });

  @override
  OrderTabViewViewState createState() => OrderTabViewViewState();
}

class OrderTabViewViewState extends State<OrderTabViewView>
    with SingleTickerProviderStateMixin {
  bool hasRefreshedOrder = false;
  late TabController _tabController;
  GetTableModel getTableModel = GetTableModel();
  GetWaiterModel getWaiterModel = GetWaiterModel();
  dynamic selectedValue;
  dynamic selectedValueWaiter;
  dynamic tableId;
  dynamic waiterId;
  bool tableLoad = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    context.read<OrderTodayBloc>().add(TableDine());
    context.read<OrderTodayBloc>().add(WaiterDine());
    _tabController.addListener(() {
      if (_tabController.index == 0 && !hasRefreshedOrder) {
        hasRefreshedOrder = true;
        widget.orderAllKey?.currentState?.refreshOrders();
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index == 0 && widget.orderAllKey != null) {
        widget.orderAllKey?.currentState?.refreshOrders();
      }
    });
  }

  void _refreshData() {
    setState(() {
      selectedValue = null;
      selectedValueWaiter = null;
      tableId = null;
      waiterId = null;
      hasRefreshedOrder = false;
    });

    context.read<OrderTodayBloc>().add(TableDine());
    context.read<OrderTodayBloc>().add(WaiterDine());
    widget.orderAllKey?.currentState?.refreshOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return DefaultTabController(
        length: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Orders",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: appPrimaryColor,
                    ),
                  ),
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Select Table',
                      style: MyTextStyle.f14(
                        blackColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Select Waiter',
                      style: MyTextStyle.f14(
                        blackColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: DropdownButtonFormField<String>(
                      value: (getTableModel.data
                                  ?.any((item) => item.name == selectedValue) ??
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
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text("All Tables"),
                        ),
                        ...?getTableModel.data?.map((item) {
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
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue;
                          if (newValue != null) {
                            final selectedItem = getTableModel.data
                                ?.firstWhere((item) => item.name == newValue);
                            tableId = selectedItem?.id.toString();
                          } else {
                            tableId = null;
                          }
                        });
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
                    margin: const EdgeInsets.all(10),
                    child: DropdownButtonFormField<String>(
                      value: (getWaiterModel.data?.any(
                                  (item) => item.name == selectedValueWaiter) ??
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
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text("All Waiters"),
                        ),
                        ...?getWaiterModel.data?.map((item) {
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
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValueWaiter = newValue;
                          if (newValue != null) {
                            final selectedItem = getWaiterModel.data
                                ?.firstWhere((item) => item.name == newValue);
                            waiterId = selectedItem?.id.toString();
                          } else {
                            waiterId = null;
                          }
                        });
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
            TabBar(
              controller: _tabController,
              labelColor: appPrimaryColor,
              unselectedLabelColor: greyColor,
              indicatorColor: appPrimaryColor,
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Line"),
                Tab(text: "Parcel"),
                Tab(text: "AC"),
                Tab(text: "HD"),
                Tab(text: "SWIGGY"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  !hasRefreshedOrder && widget.orderAllKey != null
                      ? OrderViewView(
                          key: widget.orderAllKey,
                          type: 'All',
                          selectedTableName: selectedValue,
                          selectedWaiterName: selectedValueWaiter,
                        )
                      : OrderView(
                          type: 'All',
                          selectedTableName: selectedValue,
                          selectedWaiterName: selectedValueWaiter,
                        ),
                  OrderView(
                    type: 'Line',
                    selectedTableName: selectedValue,
                    selectedWaiterName: selectedValueWaiter,
                  ),
                  OrderView(
                    type: 'Parcel',
                    selectedTableName: selectedValue,
                    selectedWaiterName: selectedValueWaiter,
                  ),
                  OrderView(
                    type: 'AC',
                    selectedTableName: selectedValue,
                    selectedWaiterName: selectedValueWaiter,
                  ),
                  OrderView(
                    type: 'HD',
                    selectedTableName: selectedValue,
                    selectedWaiterName: selectedValueWaiter,
                  ),
                  OrderView(
                    type: 'SWIGGY',
                    selectedTableName: selectedValue,
                    selectedWaiterName: selectedValueWaiter,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<OrderTodayBloc, dynamic>(
      buildWhen: ((previous, current) {
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
