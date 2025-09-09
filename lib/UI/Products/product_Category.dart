import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple/Alertbox/snackBarAlert.dart';
import 'package:simple/Bloc/Products/product_category_bloc.dart';
import 'package:simple/ModelClass/HomeScreen/Category&Product/Get_category_model.dart';
import 'package:simple/ModelClass/Products/get_products_cat_model.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/space.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Authentication/login_screen.dart';
import 'package:simple/UI/Products/pop_view_products.dart';

class ProductView extends StatelessWidget {
  final GlobalKey<ProductViewViewState>? productKey;
  bool? hasRefreshedProduct;
  ProductView({
    super.key,
    this.productKey,
    this.hasRefreshedProduct,
  });

  @override
  Widget build(BuildContext context) {
    return ProductViewView(
        productKey: productKey, hasRefreshedProduct: hasRefreshedProduct);
  }
}

class ProductViewView extends StatefulWidget {
  final GlobalKey<ProductViewViewState>? productKey;
  bool? hasRefreshedProduct;
  ProductViewView({
    super.key,
    this.productKey,
    this.hasRefreshedProduct,
  });

  @override
  ProductViewViewState createState() => ProductViewViewState();
}

class ProductViewViewState extends State<ProductViewView> {
  GetCategoryModel getCategoryModel = GetCategoryModel();
  GetProductsCatModel getProductsCatModel = GetProductsCatModel();
  dynamic selectedValue;
  dynamic categoryId;

  bool categoryLoad = false;
  bool productLoad = false;
  String? errorMessage;

  void refreshProduct() {
    if (!mounted || !context.mounted) return;
    context.read<ProductCategoryBloc>().add(
          ProductItem(categoryId ?? ""),
        );
    setState(() {
      categoryLoad = true;
      productLoad = true;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductCategoryBloc>().add(ProductCategory());

    if (widget.hasRefreshedProduct == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          categoryLoad = true;
          productLoad = true;
        });
        widget.productKey?.currentState?.refreshProduct();
      });
    } else {
      setState(() {
        categoryLoad = true;
        productLoad = true;
      });
      context.read<ProductCategoryBloc>().add(
            ProductItem(categoryId ?? ""),
          );
    }
  }

  void _refreshData() {
    setState(() {
      selectedValue = null;
      categoryId = null;
    });
    context.read<ProductCategoryBloc>().add(
          ProductItem(categoryId ?? ""),
        );
    context.read<ProductCategoryBloc>().add(ProductCategory());
    widget.productKey?.currentState?.refreshProduct();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                    Text("Category",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              verticalSpace(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    child: DropdownButtonFormField<String>(
                      value: (getCategoryModel.data
                                  ?.any((item) => item.name == selectedValue) ??
                              false)
                          ? selectedValue
                          : null,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: appPrimaryColor,
                      ),
                      isExpanded: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: appPrimaryColor,
                          ),
                        ),
                      ),
                      items: getCategoryModel.data?.map((item) {
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
                            selectedValue = newValue;
                            final selectedItem = getCategoryModel.data
                                ?.firstWhere((item) => item.name == newValue);
                            categoryId = selectedItem?.id.toString();
                            context.read<ProductCategoryBloc>().add(
                                  ProductItem(categoryId ?? ""),
                                );
                          });
                        }
                      },
                      hint: Text(
                        '-- Select Category --',
                        style: MyTextStyle.f14(
                          blackColor,
                          weight: FontWeight.normal,
                        ),
                      ),
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
                    tooltip: 'Refresh Products',
                  ),
                ],
              ),
              SizedBox(height: 24),
              productLoad
                  ? Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      alignment: Alignment.center,
                      child: const SpinKitChasingDots(
                          color: appPrimaryColor, size: 30))
                  : getProductsCatModel.data == null
                      ? Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.3),
                          alignment: Alignment.center,
                          child: Text(
                            "No Products found !!!",
                            style: MyTextStyle.f16(
                              greyColor,
                              weight: FontWeight.w500,
                            ),
                          ))
                      : Column(
                          children: getProductsCatModel.data!.categories!
                              .map(
                                (e) => Column(
                                  children: [
                                    if (e.products!.isNotEmpty) ...[
                                      Text(
                                        "${e.categoryName}",
                                        style: MyTextStyle.f16(
                                          blackColor,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Table(
                                        border: TableBorder.all(),
                                        columnWidths: const {
                                          0: FixedColumnWidth(60),
                                          1: FlexColumnWidth(),
                                          2: FlexColumnWidth(),
                                          3: FixedColumnWidth(100),
                                          4: FixedColumnWidth(100),
                                          5: FixedColumnWidth(100),
                                          6: FixedColumnWidth(100),
                                        },
                                        children: [
                                          const TableRow(
                                            decoration: BoxDecoration(
                                                color: appPrimaryColor),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text("S.No",
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text("Product Name",
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text("Product Code",
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text("Base Price",
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text("Parcel",
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text("AC",
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text("HD",
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ...List.generate(e.products!.length,
                                              (index) {
                                            final item = e.products![index];
                                            return TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Center(
                                                      child:
                                                          Text("${index + 1}")),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(item.name ?? ""),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Center(
                                                      child: Text(
                                                          item.shortCode ??
                                                              "")),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Center(
                                                      child: Text(item.basePrice
                                                              ?.toStringAsFixed(
                                                                  2) ??
                                                          "")),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Center(
                                                      child: Text(item
                                                              .parcelPrice
                                                              ?.toStringAsFixed(
                                                                  2) ??
                                                          "")),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Center(
                                                      child: Text(item.acPrice
                                                              ?.toStringAsFixed(
                                                                  2) ??
                                                          "")),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Center(
                                                      child: Text(item.hdPrice
                                                              ?.toStringAsFixed(
                                                                  2) ??
                                                          "")),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Total Count: ${e.products!.length}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ],
                                ),
                              )
                              .toList()),
              // if (getProductsCatModel.data != null)
              //   Center(
              //     child: ElevatedButton.icon(
              //       onPressed: () async {
              //         showDialog(
              //           context: context,
              //           builder: (context) =>
              //               ThermalProductsReceiptDialog(getProductsCatModel),
              //         );
              //       },
              //       icon: const Icon(Icons.print),
              //       label: const Text("Print"),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: greenColor,
              //         foregroundColor: whiteColor,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<ProductCategoryBloc, dynamic>(
      buildWhen: ((previous, current) {
        if (current is GetCategoryModel) {
          getCategoryModel = current;
          if (getCategoryModel.success == true) {
            setState(() {
              categoryLoad = false;
            });
          }
          if (getCategoryModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          return true;
        }
        if (current is GetProductsCatModel) {
          getProductsCatModel = current;
          if (getProductsCatModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          if (getProductsCatModel.success == true) {
            setState(() {
              productLoad = false;
            });
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
