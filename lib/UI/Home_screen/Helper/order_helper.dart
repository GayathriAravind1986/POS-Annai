import 'package:simple/ModelClass/Cart/Post_Add_to_billing_model.dart';

Map<String, dynamic> buildOrderPayload({
  required PostAddToBillingModel postAddToBillingModel,
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
    "items": postAddToBillingModel.items?.map((item) {
      return {
        "name": item.name,
        "product": item.id,
        "quantity": item.qty,
        "subtotal": item.subtotal,
        "unitPrice": item.basePrice,
        "addons": item.selectedAddons?.map((addon) {
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
    "subtotal": postAddToBillingModel.subtotal,
    "tableNo": tableId,
    "waiter": waiterId,
    "tax": postAddToBillingModel.totalTax,
    "total": postAddToBillingModel.total,
    "discountAmount": double.parse(discountAmount),
    "isDiscountApplied": isDiscountApplied,
    "tipAmount": double.tryParse(tipAmount) ?? 0.0,
  };
}
