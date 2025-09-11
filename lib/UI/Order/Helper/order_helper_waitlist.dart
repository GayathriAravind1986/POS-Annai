import 'package:simple/ModelClass/Order/Get_view_order_model.dart';

Map<String, dynamic> buildOrderWaitListPayload({
  required GetViewOrderModel getViewOrderModel,
  String? tableId,
  String? waiterId,
  required String orderStatus,
  required String orderType,
  required String discountAmount,
  required bool isDiscountApplied,
  required String tipAmount,
  required List<Map<String, dynamic>> payments,
}) {
  final now = DateTime.now().toUtc();

  return {
    "date": now.toIso8601String(),
    "items": getViewOrderModel.data!.items!.map((item) {
      return {
        "name": item.name,
        "product": item.product!.id,
        "quantity": item.quantity,
        "subtotal": item.subtotal,
        "unitPrice": item.unitPrice,
        "addons": item.addons?.map((addon) {
              return {
                "addon": addon.id,
                "name": addon.name,
                "price": addon.price,
              };
            }).toList() ??
            [],
      };
    }).toList(),
    "payments": payments,
    "orderStatus": orderStatus,
    "orderType": orderType,
    "subtotal": getViewOrderModel.data!.subtotal,
    "tableNo": tableId,
    "waiter": waiterId,
    "tax": getViewOrderModel.data!.tax,
    "total": getViewOrderModel.data!.total,
    "discountAmount": double.parse(discountAmount),
    "isDiscountApplied": isDiscountApplied,
    "tipAmount": double.tryParse(tipAmount) ?? 0.0,
  };
}
