import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple/Alertbox/snackBarAlert.dart';
import 'package:simple/Bloc/Category/category_bloc.dart';
import 'package:simple/ModelClass/ShopDetails/getStockMaintanencesModel.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Authentication/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onLogout;
  const CustomAppBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FoodCategoryBloc(),
      child: CustomAppBarView(
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        onLogout: onLogout,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class CustomAppBarView extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onLogout;
  const CustomAppBarView({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onLogout,
  });

  @override
  CustomAppBarViewState createState() => CustomAppBarViewState();
}

class CustomAppBarViewState extends State<CustomAppBarView> {
  GetStockMaintanencesModel getStockMaintanencesModel =
      GetStockMaintanencesModel();
  bool stockLoad = false;
  @override
  void initState() {
    super.initState();
    context.read<FoodCategoryBloc>().add(StockDetails());
    setState(() {
      stockLoad = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              getStockMaintanencesModel.data?.name != null
                  ? Text(
                      getStockMaintanencesModel.data!.name.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: appPrimaryColor,
                      ),
                    )
                  : Text(""),
              SizedBox(width: size.width * 0.2),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => widget.onTabSelected(0),
                    icon: Icon(
                      Icons.home_outlined,
                      size: 30,
                      color: widget.selectedIndex == 0
                          ? appPrimaryColor
                          : greyColor,
                    ),
                    label: Text(
                      "Home",
                      style: MyTextStyle.f16(
                        weight: FontWeight.bold,
                        widget.selectedIndex == 0 ? appPrimaryColor : greyColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => widget.onTabSelected(1),
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                      color: widget.selectedIndex == 1
                          ? appPrimaryColor
                          : greyColor,
                    ),
                    label: Text(
                      "Orders",
                      style: MyTextStyle.f16(
                        weight: FontWeight.bold,
                        widget.selectedIndex == 1 ? appPrimaryColor : greyColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => widget.onTabSelected(2),
                    icon: Icon(
                      Icons.note_alt_outlined,
                      size: 30,
                      color: widget.selectedIndex == 2
                          ? appPrimaryColor
                          : greyColor,
                    ),
                    label: Text(
                      "Report",
                      style: MyTextStyle.f16(
                        weight: FontWeight.bold,
                        widget.selectedIndex == 2 ? appPrimaryColor : greyColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  (getStockMaintanencesModel.data?.stockMaintenance == true)
                      ? TextButton.icon(
                          onPressed: () => widget.onTabSelected(3),
                          icon: Icon(
                            Icons.inventory,
                            size: 30,
                            color: widget.selectedIndex == 3
                                ? appPrimaryColor
                                : greyColor,
                          ),
                          label: Text(
                            "Stockin",
                            style: MyTextStyle.f16(
                              weight: FontWeight.bold,
                              widget.selectedIndex == 3
                                  ? appPrimaryColor
                                  : greyColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(Icons.logout, color: appPrimaryColor),
              onPressed: widget.onLogout,
            ),
          ),
        ],
      );
    }

    return BlocBuilder<FoodCategoryBloc, dynamic>(
      buildWhen: ((previous, current) {
        if (current is GetStockMaintanencesModel) {
          getStockMaintanencesModel = current;
          if (getStockMaintanencesModel.errorResponse?.isUnauthorized == true) {
            _handle401Error();
            return true;
          }
          if (getStockMaintanencesModel.success == true) {
            setState(() {
              stockLoad = false;
            });
          } else {
            setState(() {
              stockLoad = false;
            });
            showToast("No Stock found", context, color: false);
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
