import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Api/apiProvider.dart';
import 'package:simple/UI/Home_screen/home_screen.dart';

abstract class ProductCategoryEvent {}

class ProductCategory extends ProductCategoryEvent {}

class ProductItem extends ProductCategoryEvent {
  String catId;
  ProductItem(this.catId);
}

class ProductCategoryBloc extends Bloc<ProductCategoryEvent, dynamic> {
  ProductCategoryBloc() : super(dynamic) {
    on<ProductCategory>((event, emit) async {
      await ApiProvider().getCategoryAPI().then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<ProductItem>((event, emit) async {
      await ApiProvider().getProductsCatAPI(event.catId).then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
  }
}
