import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Api/apiProvider.dart';

abstract class ReportTodayEvent {}

class ReportTodayList extends ReportTodayEvent {
  String fromDate;
  String toDate;
  String tableId;
  String waiterId;
  String operatorId;
  ReportTodayList(
      this.fromDate, this.toDate, this.tableId, this.waiterId, this.operatorId);
}

class TableDine extends ReportTodayEvent {}

class WaiterDine extends ReportTodayEvent {}

class UserDetails extends ReportTodayEvent {}

class ReportTodayBloc extends Bloc<ReportTodayEvent, dynamic> {
  ReportTodayBloc() : super(dynamic) {
    on<ReportTodayList>((event, emit) async {
      await ApiProvider()
          .getReportTodayAPI(event.fromDate, event.toDate, event.tableId,
              event.waiterId, event.operatorId)
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
    on<UserDetails>((event, emit) async {
      await ApiProvider().getUserDetailsAPI().then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
  }
}
