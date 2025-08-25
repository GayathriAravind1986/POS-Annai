import 'package:simple/Bloc/Response/errorResponse.dart';

/// message : "Order updated successfully"
/// order : {"_id":"68791fb30d811d96f7a049d3","orderNumber":"ORD-20250717-0012","items":[{"product":"6856fd2f1544bf146f676866","name":"Greek Salad","quantity":1,"unitPrice":110.17,"addons":[{"addon":"6859745aca2dd77aab314117","name":"Toppins","price":0,"_id":"68792f6b0d811d96f7a04f10"},{"addon":"68763b27ff518ce12520c915","name":"Extra creams","price":30,"_id":"68792f6b0d811d96f7a04f11"}],"tax":0,"subtotal":110.17,"_id":"68792f6b0d811d96f7a04f0f"}],"subtotal":110.17,"tax":19.83,"total":130,"updatedAt":"2025-07-17T17:14:19.868Z"}
/// payments : [{"order":"68791fb30d811d96f7a049d3","paymentMethod":"CASH","amount":30,"balanceAmount":0,"status":"COMPLETED","createdAt":"2025-07-17T10:30:08.585Z","_id":"68792f6b0d811d96f7a04f18","updatedAt":"2025-07-17T17:14:19.880Z","__v":0},{"order":"68791fb30d811d96f7a049d3","paymentMethod":"CARD","amount":100,"balanceAmount":0,"status":"COMPLETED","createdAt":"2025-07-17T10:30:08.585Z","_id":"68792f6b0d811d96f7a04f1f","updatedAt":"2025-07-17T17:14:19.889Z","__v":0}]
/// invoice : {"businessName":"Roja Restaurant","address":"11 Big street, Madrasa, Tamil Nadu 600001","phone":"+91-9876543210","gstNumber":"29ABCDE1234F2Z5","currencySymbol":"₹","printType":"imin","orderStatus":"COMPLETED","items":[{"name":"Greek Salad","basePrice":110.17,"qty":1,"taxPrice":19.83,"totalPrice":130,"isAddon":false},{"name":"Toppins","basePrice":0,"qty":1,"taxPrice":0,"totalPrice":0,"isAddon":true,"isFree":false},{"name":"Extra creams","basePrice":30,"qty":1,"taxPrice":5.4,"totalPrice":35.4,"isAddon":true,"isFree":false}],"subtotal":110.17,"salesTax":19.83,"total":130,"orderNumber":"ORD-20250717-0012","date":"7/17/2025, 10:44:19 PM","paidBy":"CASH: ₹30.00, CARD: ₹100.00","transactionId":"TXN-20250717-111511","tableNo":"1"}

class UpdateGenerateOrderModel {
  UpdateGenerateOrderModel({
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

  UpdateGenerateOrderModel.fromJson(dynamic json) {
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
  UpdateGenerateOrderModel copyWith({
    String? message,
    Order? order,
    List<Payments>? payments,
    Invoice? invoice,
  }) =>
      UpdateGenerateOrderModel(
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
/// orderStatus : "COMPLETED"
/// items : [{"name":"Greek Salad","basePrice":110.17,"qty":1,"taxPrice":19.83,"totalPrice":130,"isAddon":false},{"name":"Toppins","basePrice":0,"qty":1,"taxPrice":0,"totalPrice":0,"isAddon":true,"isFree":false},{"name":"Extra creams","basePrice":30,"qty":1,"taxPrice":5.4,"totalPrice":35.4,"isAddon":true,"isFree":false}]
/// subtotal : 110.17
/// salesTax : 19.83
/// total : 130
/// orderNumber : "ORD-20250717-0012"
/// date : "7/17/2025, 10:44:19 PM"
/// paidBy : "CASH: ₹30.00, CARD: ₹100.00"
/// transactionId : "TXN-20250717-111511"
/// tableNo : "1"

class Invoice {
  Invoice({
    String? businessName,
    String? address,
    String? phone,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    String? orderStatus,
    List<InvoiceItems>? invoiceItems,
    num? subtotal,
    num? salesTax,
    num? total,
    String? orderNumber,
    List<Kot>? kot,
    String? date,
    String? paidBy,
    String? transactionId,
    String? tableNo,
    String? tableName,
    num? tipAmount,
  }) {
    _businessName = businessName;
    _address = address;
    _phone = phone;
    _gstNumber = gstNumber;
    _currencySymbol = currencySymbol;
    _printType = printType;
    _orderStatus = orderStatus;
    _invoiceItems = invoiceItems;
    _subtotal = subtotal;
    _salesTax = salesTax;
    _total = total;
    _orderNumber = orderNumber;
    _kot = kot;
    _date = date;
    _paidBy = paidBy;
    _transactionId = transactionId;
    _tableNo = tableNo;
    _tableName = tableName;
    _tipAmount = tipAmount;
  }

  Invoice.fromJson(dynamic json) {
    _businessName = json['businessName'];
    _address = json['address'];
    _phone = json['phone'];
    _gstNumber = json['gstNumber'];
    _currencySymbol = json['currencySymbol'];
    _printType = json['printType'];
    _orderStatus = json['orderStatus'];
    if (json['invoice_items'] != null) {
      _invoiceItems = [];
      json['invoice_items'].forEach((v) {
        _invoiceItems?.add(InvoiceItems.fromJson(v));
      });
    }
    _subtotal = json['subtotal'];
    _salesTax = json['salesTax'];
    _total = json['total'];
    _orderNumber = json['orderNumber'];
    if (json['kot'] != null) {
      _kot = [];
      json['kot'].forEach((v) {
        _kot?.add(Kot.fromJson(v));
      });
    }
    _date = json['date'];
    _paidBy = json['paidBy'];
    _transactionId = json['transactionId'];
    _tableNo = json['tableNo'];
    _tableName = json['tableName'];
    _tipAmount = json['tipAmount'];
  }
  String? _businessName;
  String? _address;
  String? _phone;
  String? _gstNumber;
  String? _currencySymbol;
  String? _printType;
  String? _orderStatus;
  List<InvoiceItems>? _invoiceItems;
  num? _subtotal;
  num? _salesTax;
  num? _total;
  String? _orderNumber;
  List<Kot>? _kot;
  String? _date;
  String? _paidBy;
  String? _transactionId;
  String? _tableNo;
  String? _tableName;
  num? _tipAmount;
  Invoice copyWith({
    String? businessName,
    String? address,
    String? phone,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    String? orderStatus,
    List<InvoiceItems>? invoiceItems,
    num? subtotal,
    num? salesTax,
    num? total,
    String? orderNumber,
    List<Kot>? kot,
    String? date,
    String? paidBy,
    String? transactionId,
    String? tableNo,
    String? tableName,
    num? tipAmount,
  }) =>
      Invoice(
        businessName: businessName ?? _businessName,
        address: address ?? _address,
        phone: phone ?? _phone,
        gstNumber: gstNumber ?? _gstNumber,
        currencySymbol: currencySymbol ?? _currencySymbol,
        printType: printType ?? _printType,
        orderStatus: orderStatus ?? _orderStatus,
        invoiceItems: invoiceItems ?? _invoiceItems,
        subtotal: subtotal ?? _subtotal,
        salesTax: salesTax ?? _salesTax,
        total: total ?? _total,
        orderNumber: orderNumber ?? _orderNumber,
        kot: kot ?? _kot,
        date: date ?? _date,
        paidBy: paidBy ?? _paidBy,
        transactionId: transactionId ?? _transactionId,
        tableNo: tableNo ?? _tableNo,
        tableName: tableName ?? _tableName,
        tipAmount: tipAmount ?? _tipAmount,
      );
  String? get businessName => _businessName;
  String? get address => _address;
  String? get phone => _phone;
  String? get gstNumber => _gstNumber;
  String? get currencySymbol => _currencySymbol;
  String? get printType => _printType;
  String? get orderStatus => _orderStatus;
  List<InvoiceItems>? get invoiceItems => _invoiceItems;
  num? get subtotal => _subtotal;
  num? get salesTax => _salesTax;
  num? get total => _total;
  String? get orderNumber => _orderNumber;
  List<Kot>? get kot => _kot;
  String? get date => _date;
  String? get paidBy => _paidBy;
  String? get transactionId => _transactionId;
  String? get tableNo => _tableNo;
  String? get tableName => _tableName;
  num? get tipAmount => _tipAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['businessName'] = _businessName;
    map['address'] = _address;
    map['phone'] = _phone;
    map['gstNumber'] = _gstNumber;
    map['currencySymbol'] = _currencySymbol;
    map['printType'] = _printType;
    map['orderStatus'] = _orderStatus;
    if (_invoiceItems != null) {
      map['invoice_items'] = _invoiceItems?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = _subtotal;
    map['salesTax'] = _salesTax;
    map['total'] = _total;
    map['orderNumber'] = _orderNumber;
    if (_kot != null) {
      map['kot'] = _kot?.map((v) => v.toJson()).toList();
    }
    map['date'] = _date;
    map['paidBy'] = _paidBy;
    map['transactionId'] = _transactionId;
    map['tableNo'] = _tableNo;
    map['tableName'] = _tableName;
    map['tipAmount'] = _tipAmount;
    return map;
  }
}

/// name : "Greek Salad"
/// basePrice : 110.17
/// qty : 1
/// taxPrice : 19.83
/// totalPrice : 130
/// isAddon : false

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

/// order : "68791fb30d811d96f7a049d3"
/// paymentMethod : "CASH"
/// amount : 30
/// balanceAmount : 0
/// status : "COMPLETED"
/// createdAt : "2025-07-17T10:30:08.585Z"
/// _id : "68792f6b0d811d96f7a04f18"
/// updatedAt : "2025-07-17T17:14:19.880Z"
/// __v : 0
///
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

/// _id : "68791fb30d811d96f7a049d3"
/// orderNumber : "ORD-20250717-0012"
/// items : [{"product":"6856fd2f1544bf146f676866","name":"Greek Salad","quantity":1,"unitPrice":110.17,"addons":[{"addon":"6859745aca2dd77aab314117","name":"Toppins","price":0,"_id":"68792f6b0d811d96f7a04f10"},{"addon":"68763b27ff518ce12520c915","name":"Extra creams","price":30,"_id":"68792f6b0d811d96f7a04f11"}],"tax":0,"subtotal":110.17,"_id":"68792f6b0d811d96f7a04f0f"}]
/// subtotal : 110.17
/// tax : 19.83
/// total : 130
/// updatedAt : "2025-07-17T17:14:19.868Z"

class Order {
  Order({
    String? id,
    String? orderNumber,
    List<Items>? items,
    num? subtotal,
    String? orderType,
    num? tax,
    num? total,
    String? updatedAt,
  }) {
    _id = id;
    _orderNumber = orderNumber;
    _items = items;
    _subtotal = subtotal;
    _orderType = orderType;
    _tax = tax;
    _total = total;
    _updatedAt = updatedAt;
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
    _subtotal = json['subtotal'];
    _orderType = json['orderType'];
    _tax = json['tax'];
    _total = json['total'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _orderNumber;
  List<Items>? _items;
  num? _subtotal;
  String? _orderType;
  num? _tax;
  num? _total;
  String? _updatedAt;
  Order copyWith({
    String? id,
    String? orderNumber,
    List<Items>? items,
    num? subtotal,
    String? orderType,
    num? tax,
    num? total,
    String? updatedAt,
  }) =>
      Order(
        id: id ?? _id,
        orderNumber: orderNumber ?? _orderNumber,
        items: items ?? _items,
        subtotal: subtotal ?? _subtotal,
        orderType: orderType ?? _orderType,
        tax: tax ?? _tax,
        total: total ?? _total,
        updatedAt: updatedAt ?? _updatedAt,
      );
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  List<Items>? get items => _items;
  num? get subtotal => _subtotal;
  String? get orderType => _orderType;
  num? get tax => _tax;
  num? get total => _total;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderNumber'] = _orderNumber;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = _subtotal;
    map['orderType'] = _orderType;
    map['tax'] = _tax;
    map['total'] = _total;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

/// product : "6856fd2f1544bf146f676866"
/// name : "Greek Salad"
/// quantity : 1
/// unitPrice : 110.17
/// addons : [{"addon":"6859745aca2dd77aab314117","name":"Toppins","price":0,"_id":"68792f6b0d811d96f7a04f10"},{"addon":"68763b27ff518ce12520c915","name":"Extra creams","price":30,"_id":"68792f6b0d811d96f7a04f11"}]
/// tax : 0
/// subtotal : 110.17
/// _id : "68792f6b0d811d96f7a04f0f"

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

/// addon : "6859745aca2dd77aab314117"
/// name : "Toppins"
/// price : 0
/// _id : "68792f6b0d811d96f7a04f10"

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
