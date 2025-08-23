import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Api/apiProvider.dart';

abstract class OrderTodayEvent {}

class OrderTodayList extends OrderTodayEvent {
  String fromDate;
  String toDate;
  String tableId;
  String waiterId;
  OrderTodayList(this.fromDate, this.toDate, this.tableId, this.waiterId);
}

class DeleteOrder extends OrderTodayEvent {
  String? orderId;
  DeleteOrder(this.orderId);
}

class ViewOrder extends OrderTodayEvent {
  String? orderId;
  ViewOrder(this.orderId);
}

class TableDine extends OrderTodayEvent {}

class WaiterDine extends OrderTodayEvent {}

class OrderTodayBloc extends Bloc<OrderTodayEvent, dynamic> {
  OrderTodayBloc() : super(dynamic) {
    on<OrderTodayList>((event, emit) async {
      await ApiProvider()
          .getOrderTodayAPI(
              event.fromDate, event.toDate, event.tableId, event.waiterId)
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<DeleteOrder>((event, emit) async {
      await ApiProvider().deleteOrderAPI(event.orderId).then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<ViewOrder>((event, emit) async {
      await ApiProvider().viewOrderAPI(event.orderId).then((value) {
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
  }
}
