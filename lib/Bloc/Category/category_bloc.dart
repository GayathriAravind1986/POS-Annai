import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Api/apiProvider.dart';
import 'package:simple/UI/Home_screen/home_screen.dart';

abstract class FoodCategoryEvent {}

class FoodCategory extends FoodCategoryEvent {}

class FoodProductItem extends FoodCategoryEvent {
  String catId;
  String searchKey;
  FoodProductItem(this.catId, this.searchKey);
}

class AddToBilling extends FoodCategoryEvent {
  List<Map<String, dynamic>> billingItems;
  bool? isDiscount;
  final OrderType? orderType;
  AddToBilling(this.billingItems, this.isDiscount, this.orderType);
}

class GenerateOrder extends FoodCategoryEvent {
  final String orderPayloadJson;
  GenerateOrder(this.orderPayloadJson);
}

class UpdateOrder extends FoodCategoryEvent {
  final String orderPayloadJson;
  String? orderId;
  UpdateOrder(this.orderPayloadJson, this.orderId);
}

class TableDine extends FoodCategoryEvent {}

class WaiterDine extends FoodCategoryEvent {}

class StockDetails extends FoodCategoryEvent {}

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, dynamic> {
  FoodCategoryBloc() : super(dynamic) {
    on<FoodCategory>((event, emit) async {
      await ApiProvider().getCategoryAPI().then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<FoodProductItem>((event, emit) async {
      await ApiProvider()
          .getProductItemAPI(event.catId, event.searchKey)
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<AddToBilling>((event, emit) async {
      await ApiProvider()
          .postAddToBillingAPI(
        event.billingItems,
        event.isDiscount,
        event.orderType?.apiValue,
      )
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<GenerateOrder>((event, emit) async {
      await ApiProvider()
          .postGenerateOrderAPI(event.orderPayloadJson)
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<UpdateOrder>((event, emit) async {
      await ApiProvider()
          .updateGenerateOrderAPI(event.orderPayloadJson, event.orderId)
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<TableDine>((event, emit) async {
      await ApiProvider().getTableAPI().then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<WaiterDine>((event, emit) async {
      await ApiProvider().getWaiterAPI().then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<StockDetails>((event, emit) async {
      await ApiProvider().getStockDetailsAPI().then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
  }
}
