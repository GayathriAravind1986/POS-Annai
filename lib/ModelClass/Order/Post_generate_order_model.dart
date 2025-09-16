import 'package:simple/Bloc/Response/errorResponse.dart';

/// message : "Order created successfully"
/// order : {"_id":"687641b8ff518ce12520c9b3","orderNumber":"ORD-20250715-0008","items":[{"product":"685b7fa98753e2ece10465e7","name":"White forest","quantity":3,"unitPrice":56.49666666666667,"addons":[{"addon":"60a7e4f8a2f8f3b6e8d9b7c5","name":"Cheese","price":10,"_id":"687641b8ff518ce12520c9b5"}],"tax":0,"subtotal":189.49,"_id":"687641b8ff518ce12520c9b4"}],"subtotal":169.49,"tax":30.51,"total":200,"createdAt":"2025-07-15T11:10:59.577Z"}
/// payments : []
/// invoice : {"businessName":"Roja Restaurant","address":"11 Big street, Madrasa, Tamil Nadu 600001","phone":"+91-9876543210","gstNumber":"29ABCDE1234F2Z5","currencySymbol":"₹","printType":"imin","items":[{"name":"White forest","basePrice":56.49666666666667,"qty":3,"taxPrice":34.11021240191162,"totalPrice":223.60021240191162}],"subtotal":169.49,"salesTax":30.51,"total":200,"orderNumber":"ORD-20250715-0008","orderStatus":"WAITLIST","date":"7/15/2025, 5:25:36 PM","paidBy":"N/A","transactionId":"TXN-20250715-082781","tableNo":"N/A"}

class PostGenerateOrderModel {
  PostGenerateOrderModel({
    String? message,
    Order? order,
    List<Payments>? payments,
    Invoice? invoice,
    ErrorResponse? errorResponse,
  }) {
    _message = message;
    _order = order;
    _payments = payments;
    _invoice = invoice;
  }

  PostGenerateOrderModel.fromJson(dynamic json) {
    _message = json['message'];
    _order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if (json['payments'] != null) {
      _payments = [];
      json['payments'].forEach((v) {
        _payments?.add(Payments.fromJson(v));
      });
    }
    _invoice =
        json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  String? _message;
  Order? _order;
  List<Payments>? _payments;
  Invoice? _invoice;
  ErrorResponse? errorResponse;
  PostGenerateOrderModel copyWith({
    String? message,
    Order? order,
    List<Payments>? payments,
    Invoice? invoice,
  }) =>
      PostGenerateOrderModel(
        message: message ?? _message,
        order: order ?? _order,
        payments: payments ?? _payments,
        invoice: invoice ?? _invoice,
      );
  String? get message => _message;
  Order? get order => _order;
  List<Payments>? get payments => _payments;
  Invoice? get invoice => _invoice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_order != null) {
      map['order'] = _order?.toJson();
    }
    if (_payments != null) {
      map['payments'] = _payments?.map((v) => v.toJson()).toList();
    }
    if (_invoice != null) {
      map['invoice'] = _invoice?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// businessName : "Roja Restaurant"
/// address : "11 Big street, Madrasa, Tamil Nadu 600001"
/// phone : "+91-9876543210"
/// gstNumber : "29ABCDE1234F2Z5"
/// currencySymbol : "₹"
/// printType : "imin"
/// items : [{"name":"White forest","basePrice":56.49666666666667,"qty":3,"taxPrice":34.11021240191162,"totalPrice":223.60021240191162}]
/// subtotal : 169.49
/// salesTax : 30.51
/// total : 200
/// orderNumber : "ORD-20250715-0008"
/// orderStatus : "WAITLIST"
/// date : "7/15/2025, 5:25:36 PM"
/// paidBy : "N/A"
/// transactionId : "TXN-20250715-082781"
/// tableNo : "N/A"
class Payments {
  Payments({
    String? order,
    String? paymentMethod,
    num? amount,
    num? balanceAmount,
    String? status,
    String? createdAt,
    String? id,
    String? updatedAt,
    num? v,
  }) {
    _order = order;
    _paymentMethod = paymentMethod;
    _amount = amount;
    _balanceAmount = balanceAmount;
    _status = status;
    _createdAt = createdAt;
    _id = id;
    _updatedAt = updatedAt;
    _v = v;
  }

  Payments.fromJson(dynamic json) {
    _order = json['order'];
    _paymentMethod = json['paymentMethod'];
    _amount = json['amount'];
    _balanceAmount = json['balanceAmount'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _id = json['_id'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _order;
  String? _paymentMethod;
  num? _amount;
  num? _balanceAmount;
  String? _status;
  String? _createdAt;
  String? _id;
  String? _updatedAt;
  num? _v;
  Payments copyWith({
    String? order,
    String? paymentMethod,
    num? amount,
    num? balanceAmount,
    String? status,
    String? createdAt,
    String? id,
    String? updatedAt,
    num? v,
  }) =>
      Payments(
        order: order ?? _order,
        paymentMethod: paymentMethod ?? _paymentMethod,
        amount: amount ?? _amount,
        balanceAmount: balanceAmount ?? _balanceAmount,
        status: status ?? _status,
        createdAt: createdAt ?? _createdAt,
        id: id ?? _id,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  String? get order => _order;
  String? get paymentMethod => _paymentMethod;
  num? get amount => _amount;
  num? get balanceAmount => _balanceAmount;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get id => _id;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order'] = _order;
    map['paymentMethod'] = _paymentMethod;
    map['amount'] = _amount;
    map['balanceAmount'] = _balanceAmount;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['_id'] = _id;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}

class Invoice {
  Invoice({
    String? businessName,
    String? address,
    String? phone,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    String? thermalIp,
    List<InvoiceItems>? invoiceItems,
    num? subtotal,
    num? salesTax,
    List<FinalTaxes>? finalTaxes,
    num? total,
    String? orderNumber,
    String? orderStatus,
    List<Kot>? kot,
    String? date,
    String? paidBy,
    String? transactionId,
    String? tableNum,
    String? tableName,
    String? waiterName,
    String? orderType,
    num? tipAmount,
  }) {
    _businessName = businessName;
    _address = address;
    _phone = phone;
    _gstNumber = gstNumber;
    _currencySymbol = currencySymbol;
    _printType = printType;
    _thermalIp = thermalIp;
    _invoiceItems = invoiceItems;
    _subtotal = subtotal;
    _finalTaxes = finalTaxes;
    _salesTax = salesTax;
    _total = total;
    _orderNumber = orderNumber;
    _orderStatus = orderStatus;
    _kot = kot;
    _date = date;
    _paidBy = paidBy;
    _transactionId = transactionId;
    _tableNum = tableNum;
    _tableName = tableName;
    _waiterName = waiterName;
    _orderType = orderType;
    _tipAmount = tipAmount;
  }

  Invoice.fromJson(dynamic json) {
    _businessName = json['businessName'];
    _address = json['address'];
    _phone = json['phone'];
    _gstNumber = json['gstNumber'];
    _currencySymbol = json['currencySymbol'];
    _printType = json['printType'];
    _thermalIp = json['thermalIp'];
    if (json['invoice_items'] != null) {
      _invoiceItems = [];
      json['invoice_items'].forEach((v) {
        _invoiceItems?.add(InvoiceItems.fromJson(v));
      });
    }
    _subtotal = json['subtotal'];
    if (json['finalTaxes'] != null) {
      _finalTaxes = [];
      json['finalTaxes'].forEach((v) {
        _finalTaxes?.add(FinalTaxes.fromJson(v));
      });
    }
    _salesTax = json['salesTax'];
    _total = json['total'];
    _orderNumber = json['orderNumber'];
    _orderStatus = json['orderStatus'];
    if (json['kot'] != null) {
      _kot = [];
      json['kot'].forEach((v) {
        _kot?.add(Kot.fromJson(v));
      });
    }
    _date = json['date'];
    _paidBy = json['paidBy'];
    _transactionId = json['transactionId'];
    _tableNum = json['tableNum'];
    _tableName = json['tableName'];
    _waiterName = json['waiterName'];
    _orderType = json['orderType'];
    _tipAmount = json['tipAmount'];
  }
  String? _businessName;
  String? _address;
  String? _phone;
  String? _gstNumber;
  String? _currencySymbol;
  String? _printType;
  String? _thermalIp;
  List<InvoiceItems>? _invoiceItems;
  num? _subtotal;
  List<FinalTaxes>? _finalTaxes;
  num? _salesTax;
  num? _total;
  String? _orderNumber;
  String? _orderStatus;
  List<Kot>? _kot;
  String? _date;
  String? _paidBy;
  String? _transactionId;
  String? _tableNum;
  String? _tableName;
  String? _waiterName;
  String? _orderType;
  num? _tipAmount;
  Invoice copyWith({
    String? businessName,
    String? address,
    String? phone,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    String? thermalIp,
    List<InvoiceItems>? invoiceItems,
    num? subtotal,
    List<FinalTaxes>? finalTaxes,
    num? salesTax,
    num? total,
    String? orderNumber,
    String? orderStatus,
    List<Kot>? kot,
    String? date,
    String? paidBy,
    String? transactionId,
    String? tableNum,
    String? tableName,
    String? waiterName,
    String? orderType,
    num? tipAmount,
  }) =>
      Invoice(
        businessName: businessName ?? _businessName,
        address: address ?? _address,
        phone: phone ?? _phone,
        gstNumber: gstNumber ?? _gstNumber,
        currencySymbol: currencySymbol ?? _currencySymbol,
        printType: printType ?? _printType,
        thermalIp: thermalIp ?? _thermalIp,
        invoiceItems: invoiceItems ?? _invoiceItems,
        subtotal: subtotal ?? _subtotal,
        finalTaxes: finalTaxes ?? _finalTaxes,
        salesTax: salesTax ?? _salesTax,
        total: total ?? _total,
        orderNumber: orderNumber ?? _orderNumber,
        orderStatus: orderStatus ?? _orderStatus,
        kot: kot ?? _kot,
        date: date ?? _date,
        paidBy: paidBy ?? _paidBy,
        transactionId: transactionId ?? _transactionId,
        tableNum: tableNum ?? _tableNum,
        tableName: tableName ?? _tableName,
        waiterName: waiterName ?? _waiterName,
        orderType: orderType ?? _orderType,
        tipAmount: tipAmount ?? _tipAmount,
      );
  String? get businessName => _businessName;
  String? get address => _address;
  String? get phone => _phone;
  String? get gstNumber => _gstNumber;
  String? get currencySymbol => _currencySymbol;
  String? get printType => _printType;
  String? get thermalIp => _thermalIp;
  List<InvoiceItems>? get invoiceItems => _invoiceItems;
  num? get subtotal => _subtotal;
  List<FinalTaxes>? get finalTaxes => _finalTaxes;
  num? get salesTax => _salesTax;
  num? get total => _total;
  String? get orderNumber => _orderNumber;
  String? get orderStatus => _orderStatus;
  List<Kot>? get kot => _kot;
  String? get date => _date;
  String? get paidBy => _paidBy;
  String? get transactionId => _transactionId;
  String? get tableNum => _tableNum;
  String? get tableName => _tableName;
  String? get waiterName => _waiterName;
  String? get orderType => _orderType;
  num? get tipAmount => _tipAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['businessName'] = _businessName;
    map['address'] = _address;
    map['phone'] = _phone;
    map['gstNumber'] = _gstNumber;
    map['currencySymbol'] = _currencySymbol;
    map['printType'] = _printType;
    map['thermalIp'] = _thermalIp;
    if (_invoiceItems != null) {
      map['invoice_items'] = _invoiceItems?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = _subtotal;
    map['salesTax'] = _salesTax;
    if (_finalTaxes != null) {
      map['finalTaxes'] = _finalTaxes?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    map['orderNumber'] = _orderNumber;
    map['orderStatus'] = _orderStatus;
    if (_kot != null) {
      map['kot'] = _kot?.map((v) => v.toJson()).toList();
    }
    map['date'] = _date;
    map['paidBy'] = _paidBy;
    map['transactionId'] = _transactionId;
    map['tableNum'] = _tableNum;
    map['tableName'] = _tableName;
    map['waiterName'] = _waiterName;
    map['orderType'] = _orderType;
    map['tipAmount'] = _tipAmount;
    return map;
  }
}

class FinalTaxes {
  FinalTaxes({
    String? name,
    num? percentage,
    num? amount,
  }) {
    _name = name;
    _percentage = percentage;
    _amount = amount;
  }

  FinalTaxes.fromJson(dynamic json) {
    _name = json['name'];
    _percentage = json['percentage'];
    _amount = json['amount'];
  }
  String? _name;
  num? _percentage;
  num? _amount;
  FinalTaxes copyWith({
    String? name,
    num? percentage,
    num? amount,
  }) =>
      FinalTaxes(
        name: name ?? _name,
        percentage: percentage ?? _percentage,
        amount: amount ?? _amount,
      );
  String? get name => _name;
  num? get percentage => _percentage;
  num? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['percentage'] = _percentage;
    map['amount'] = _amount;
    return map;
  }
}

/// name : "PANNER SCHZWAN FRIED RICE"
/// quantity : 2

class Kot {
  Kot({
    String? name,
    num? quantity,
  }) {
    _name = name;
    _quantity = quantity;
  }

  Kot.fromJson(dynamic json) {
    _name = json['name'];
    _quantity = json['quantity'];
  }
  String? _name;
  num? _quantity;
  Kot copyWith({
    String? name,
    num? quantity,
  }) =>
      Kot(
        name: name ?? _name,
        quantity: quantity ?? _quantity,
      );
  String? get name => _name;
  num? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['quantity'] = _quantity;
    return map;
  }
}

/// name : "White forest"
/// basePrice : 56.49666666666667
/// qty : 3
/// taxPrice : 34.11021240191162
/// totalPrice : 223.60021240191162

class InvoiceItems {
  InvoiceItems({
    String? name,
    num? basePrice,
    num? qty,
    num? taxPrice,
    num? totalPrice,
    bool? isAddon,
  }) {
    _name = name;
    _basePrice = basePrice;
    _qty = qty;
    _taxPrice = taxPrice;
    _totalPrice = totalPrice;
    _isAddon = isAddon;
  }

  InvoiceItems.fromJson(dynamic json) {
    _name = json['name'];
    _basePrice = json['basePrice'];
    _qty = json['qty'];
    _taxPrice = json['taxPrice'];
    _totalPrice = json['totalPrice'];
    _isAddon = json['isAddon'];
  }
  String? _name;
  num? _basePrice;
  num? _qty;
  num? _taxPrice;
  num? _totalPrice;
  bool? _isAddon;
  InvoiceItems copyWith({
    String? name,
    num? basePrice,
    num? qty,
    num? taxPrice,
    num? totalPrice,
    bool? isAddon,
  }) =>
      InvoiceItems(
        name: name ?? _name,
        basePrice: basePrice ?? _basePrice,
        qty: qty ?? _qty,
        taxPrice: taxPrice ?? _taxPrice,
        totalPrice: totalPrice ?? _totalPrice,
        isAddon: isAddon ?? _isAddon,
      );
  String? get name => _name;
  num? get basePrice => _basePrice;
  num? get qty => _qty;
  num? get taxPrice => _taxPrice;
  num? get totalPrice => _totalPrice;
  bool? get isAddon => _isAddon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['basePrice'] = _basePrice;
    map['qty'] = _qty;
    map['taxPrice'] = _taxPrice;
    map['totalPrice'] = _totalPrice;
    map['isAddon'] = _isAddon;
    return map;
  }
}

/// _id : "687641b8ff518ce12520c9b3"
/// orderNumber : "ORD-20250715-0008"
/// items : [{"product":"685b7fa98753e2ece10465e7","name":"White forest","quantity":3,"unitPrice":56.49666666666667,"addons":[{"addon":"60a7e4f8a2f8f3b6e8d9b7c5","name":"Cheese","price":10,"_id":"687641b8ff518ce12520c9b5"}],"tax":0,"subtotal":189.49,"_id":"687641b8ff518ce12520c9b4"}]
/// subtotal : 169.49
/// tax : 30.51
/// total : 200
/// createdAt : "2025-07-15T11:10:59.577Z"

class Order {
  Order({
    String? id,
    String? orderNumber,
    List<Items>? items,
    List<FinalTaxes>? finalTaxes,
    num? subtotal,
    String? orderType,
    num? tax,
    num? total,
    String? createdAt,
  }) {
    _id = id;
    _orderNumber = orderNumber;
    _items = items;
    _finalTaxes = finalTaxes;
    _subtotal = subtotal;
    _orderType = orderType;
    _tax = tax;
    _total = total;
    _createdAt = createdAt;
  }

  Order.fromJson(dynamic json) {
    _id = json['_id'];
    _orderNumber = json['orderNumber'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    if (json['finalTaxes'] != null) {
      _finalTaxes = [];
      json['finalTaxes'].forEach((v) {
        _finalTaxes?.add(FinalTaxes.fromJson(v));
      });
    }
    _subtotal = json['subtotal'];
    _orderType = json['orderType'];
    _tax = json['tax'];
    _total = json['total'];
    _createdAt = json['createdAt'];
  }
  String? _id;
  String? _orderNumber;
  List<Items>? _items;
  List<FinalTaxes>? _finalTaxes;
  num? _subtotal;
  String? _orderType;
  num? _tax;
  num? _total;
  String? _createdAt;
  Order copyWith({
    String? id,
    String? orderNumber,
    List<Items>? items,
    List<FinalTaxes>? finalTaxes,
    num? subtotal,
    String? orderType,
    num? tax,
    num? total,
    String? createdAt,
  }) =>
      Order(
        id: id ?? _id,
        orderNumber: orderNumber ?? _orderNumber,
        items: items ?? _items,
        finalTaxes: finalTaxes ?? _finalTaxes,
        subtotal: subtotal ?? _subtotal,
        orderType: orderType ?? _orderType,
        tax: tax ?? _tax,
        total: total ?? _total,
        createdAt: createdAt ?? _createdAt,
      );
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  List<Items>? get items => _items;
  List<FinalTaxes>? get finalTaxes => _finalTaxes;
  num? get subtotal => _subtotal;
  String? get orderType => _orderType;
  num? get tax => _tax;
  num? get total => _total;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderNumber'] = _orderNumber;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    if (_finalTaxes != null) {
      map['finalTaxes'] = _finalTaxes?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = _subtotal;
    map['orderType'] = _orderType;
    map['tax'] = _tax;
    map['total'] = _total;
    map['createdAt'] = _createdAt;
    return map;
  }
}

/// product : "685b7fa98753e2ece10465e7"
/// name : "White forest"
/// quantity : 3
/// unitPrice : 56.49666666666667
/// addons : [{"addon":"60a7e4f8a2f8f3b6e8d9b7c5","name":"Cheese","price":10,"_id":"687641b8ff518ce12520c9b5"}]
/// tax : 0
/// subtotal : 189.49
/// _id : "687641b8ff518ce12520c9b4"
class Kotitems {
  Kotitems({
    String? name,
    num? quantity,
  }) {
    _name = name;
    _quantity = quantity;
  }

  Kotitems.fromJson(dynamic json) {
    _name = json['name'];
    _quantity = json['quantity'];
  }
  String? _name;
  num? _quantity;
  Kotitems copyWith({
    String? name,
    num? quantity,
  }) =>
      Kotitems(
        name: name ?? _name,
        quantity: quantity ?? _quantity,
      );
  String? get name => _name;
  num? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['quantity'] = _quantity;
    return map;
  }
}

class Items {
  Items({
    String? product,
    String? name,
    num? quantity,
    num? unitPrice,
    List<Addons>? addons,
    num? tax,
    num? subtotal,
    String? id,
  }) {
    _product = product;
    _name = name;
    _quantity = quantity;
    _unitPrice = unitPrice;
    _addons = addons;
    _tax = tax;
    _subtotal = subtotal;
    _id = id;
  }

  Items.fromJson(dynamic json) {
    _product = json['product'];
    _name = json['name'];
    _quantity = json['quantity'];
    _unitPrice = json['unitPrice'];
    if (json['addons'] != null) {
      _addons = [];
      json['addons'].forEach((v) {
        _addons?.add(Addons.fromJson(v));
      });
    }
    _tax = json['tax'];
    _subtotal = json['subtotal'];
    _id = json['_id'];
  }
  String? _product;
  String? _name;
  num? _quantity;
  num? _unitPrice;
  List<Addons>? _addons;
  num? _tax;
  num? _subtotal;
  String? _id;
  Items copyWith({
    String? product,
    String? name,
    num? quantity,
    num? unitPrice,
    List<Addons>? addons,
    num? tax,
    num? subtotal,
    String? id,
  }) =>
      Items(
        product: product ?? _product,
        name: name ?? _name,
        quantity: quantity ?? _quantity,
        unitPrice: unitPrice ?? _unitPrice,
        addons: addons ?? _addons,
        tax: tax ?? _tax,
        subtotal: subtotal ?? _subtotal,
        id: id ?? _id,
      );
  String? get product => _product;
  String? get name => _name;
  num? get quantity => _quantity;
  num? get unitPrice => _unitPrice;
  List<Addons>? get addons => _addons;
  num? get tax => _tax;
  num? get subtotal => _subtotal;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product'] = _product;
    map['name'] = _name;
    map['quantity'] = _quantity;
    map['unitPrice'] = _unitPrice;
    if (_addons != null) {
      map['addons'] = _addons?.map((v) => v.toJson()).toList();
    }
    map['tax'] = _tax;
    map['subtotal'] = _subtotal;
    map['_id'] = _id;
    return map;
  }
}

/// addon : "60a7e4f8a2f8f3b6e8d9b7c5"
/// name : "Cheese"
/// price : 10
/// _id : "687641b8ff518ce12520c9b5"

class Addons {
  Addons({
    String? addon,
    String? name,
    num? price,
    String? id,
  }) {
    _addon = addon;
    _name = name;
    _price = price;
    _id = id;
  }

  Addons.fromJson(dynamic json) {
    _addon = json['addon'];
    _name = json['name'];
    _price = json['price'];
    _id = json['_id'];
  }
  String? _addon;
  String? _name;
  num? _price;
  String? _id;
  Addons copyWith({
    String? addon,
    String? name,
    num? price,
    String? id,
  }) =>
      Addons(
        addon: addon ?? _addon,
        name: name ?? _name,
        price: price ?? _price,
        id: id ?? _id,
      );
  String? get addon => _addon;
  String? get name => _name;
  num? get price => _price;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addon'] = _addon;
    map['name'] = _name;
    map['price'] = _price;
    map['_id'] = _id;
    return map;
  }
}
