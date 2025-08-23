import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Api/apiProvider.dart';

abstract class ReportTodayEvent {}

class ReportTodayList extends ReportTodayEvent {
  String fromDate;
  String toDate;
  String tableId;
  String waiterId;
  ReportTodayList(this.fromDate, this.toDate,this.tableId,this.waiterId);
}
class TableDine extends ReportTodayEvent {}

class WaiterDine extends ReportTodayEvent {}
class ReportTodayBloc extends Bloc<ReportTodayEvent, dynamic> {
  ReportTodayBloc() : super(dynamic) {
    on<ReportTodayList>((event, emit) async {
      await ApiProvider()
          .getReportTodayAPI(event.fromDate, event.toDate,event.tableId,event.waiterId)
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
  }
}
