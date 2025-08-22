import 'package:simple/Bloc/Response/errorResponse.dart';

/// success : true
/// data : {"_id":"68778779ff518ce12520f056","orderNumber":"ORD-20250716-0023","items":[{"product":"6856fd071544bf146f676858","name":"Garden Salad","quantity":1,"unitPrice":63.56,"addons":[{"addon":"60a7e4f8a2f8f3b6e8d9b7c5","name":"Cheese","price":10,"_id":"68778779ff518ce12520f058"}],"tax":0,"subtotal":63.56,"_id":"68778779ff518ce12520f057"}],"subtotal":63.56,"tax":11.44,"total":75,"tableNo":null,"orderType":"TAKE-AWAY","orderStatus":"COMPLETED","operator":"6858f4ac1544bf146f676c8b","notes":"Take Away order","createdAt":"2025-07-16T11:10:59.577Z","updatedAt":"2025-07-16T11:05:29.844Z","__v":0}

class GetViewOrderModel {
  GetViewOrderModel({
    bool? success,
    Data? data,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
  }

  GetViewOrderModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  Data? _data;
  ErrorResponse? errorResponse;
  GetViewOrderModel copyWith({
    bool? success,
    Data? data,
  }) =>
      GetViewOrderModel(
        success: success ?? _success,
        data: data ?? _data,
      );
  bool? get success => _success;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// _id : "68778779ff518ce12520f056"
/// orderNumber : "ORD-20250716-0023"
/// items : [{"product":"6856fd071544bf146f676858","name":"Garden Salad","quantity":1,"unitPrice":63.56,"addons":[{"addon":"60a7e4f8a2f8f3b6e8d9b7c5","name":"Cheese","price":10,"_id":"68778779ff518ce12520f058"}],"tax":0,"subtotal":63.56,"_id":"68778779ff518ce12520f057"}]
/// subtotal : 63.56
/// tax : 11.44
/// total : 75
/// tableNo : null
/// orderType : "TAKE-AWAY"
/// orderStatus : "COMPLETED"
/// operator : "6858f4ac1544bf146f676c8b"
/// notes : "Take Away order"
/// createdAt : "2025-07-16T11:10:59.577Z"
/// updatedAt : "2025-07-16T11:05:29.844Z"
/// __v : 0

class Data {
  Data({
    String? id,
    String? orderNumber,
    List<Items>? items,
    num? subtotal,
    num? tax,
    num? total,
    String? tableNo,
    String? waiter,
    String? orderType,
    bool? isDeleted,
    String? orderStatus,
    Operator? operator,
    String? locationId,
    bool? isDiscountApplied,
    num? discountAmount,
    num? tipAmount,
    String? notes,
    String? createdAt,
    String? updatedAt,
    num? v,
    List<Payments>? payments,
    String? tableName,
    String? waiterName,
    Invoice? invoice,
  }) {
    _id = id;
    _orderNumber = orderNumber;
    _items = items;
    _subtotal = subtotal;
    _tax = tax;
    _total = total;
    _tableNo = tableNo;
    _waiter = waiter;
    _orderType = orderType;
    _isDeleted = isDeleted;
    _orderStatus = orderStatus;
    _locationId = locationId;
    _operator = operator;
    _isDiscountApplied = isDiscountApplied;
    _discountAmount = discountAmount;
    _tipAmount = tipAmount;
    _notes = notes;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _payments = payments;
    _tableName = tableName;
    _waiterName = waiterName;
    _invoice = invoice;
  }

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _orderNumber = json['orderNumber'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _subtotal = json['subtotal'];
    _tax = json['tax'];
    _total = json['total'];
    _tableNo = json['tableNo'];
    _waiter = json['waiter'];
    _orderType = json['orderType'];
    _orderStatus = json['orderStatus'];
    _isDeleted = json['isDeleted'];
    _locationId = json['locationId'];
    _operator =
        json['operator'] != null ? Operator.fromJson(json['operator']) : null;
    _isDiscountApplied = json['isDiscountApplied'];
    _discountAmount = json['discountAmount'];
    _tipAmount = json['tipAmount'];
    _notes = json['notes'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    if (json['payments'] != null) {
      _payments = [];
      json['payments'].forEach((v) {
        _payments?.add(Payments.fromJson(v));
      });
    }
    _tableName = json['tableName'];
    _waiterName = json['waiterName'];
    _invoice =
        json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null;
  }
  String? _id;
  String? _orderNumber;
  List<Items>? _items;
  num? _subtotal;
  num? _tax;
  num? _total;
  String? _tableNo;
  String? _waiter;
  String? _orderType;
  String? _orderStatus;
  bool? _isDeleted;
  String? _locationId;
  Operator? _operator;
  bool? _isDiscountApplied;
  num? _discountAmount;
  num? _tipAmount;
  String? _notes;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  List<Payments>? _payments;
  String? _tableName;
  String? _waiterName;
  Invoice? _invoice;
  Data copyWith({
    String? id,
    String? orderNumber,
    List<Items>? items,
    num? subtotal,
    num? tax,
    num? total,
    String? tableNo,
    String? waiter,
    String? orderType,
    String? orderStatus,
    bool? isDeleted,
    String? locationId,
    Operator? operator,
    bool? isDiscountApplied,
    num? discountAmount,
    num? tipAmount,
    String? notes,
    String? createdAt,
    String? updatedAt,
    num? v,
    List<Payments>? payments,
    String? tableName,
    String? waiterName,
    Invoice? invoice,
  }) =>
      Data(
        id: id ?? _id,
        orderNumber: orderNumber ?? _orderNumber,
        items: items ?? _items,
        subtotal: subtotal ?? _subtotal,
        tax: tax ?? _tax,
        total: total ?? _total,
        tableNo: tableNo ?? _tableNo,
        waiter: waiter ?? _waiter,
        isDeleted: isDeleted ?? _isDeleted,
        orderType: orderType ?? _orderType,
        orderStatus: orderStatus ?? _orderStatus,
        locationId: locationId ?? _locationId,
        operator: operator ?? _operator,
        isDiscountApplied: isDiscountApplied ?? _isDiscountApplied,
        discountAmount: discountAmount ?? _discountAmount,
        tipAmount: tipAmount ?? _tipAmount,
        notes: notes ?? _notes,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
        payments: payments ?? _payments,
        tableName: tableName ?? _tableName,
        waiterName: waiterName ?? _waiterName,
        invoice: invoice ?? _invoice,
      );
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  List<Items>? get items => _items;
  num? get subtotal => _subtotal;
  num? get tax => _tax;
  num? get total => _total;
  String? get tableNo => _tableNo;
  String? get waiter => _waiter;
  String? get orderType => _orderType;
  String? get orderStatus => _orderStatus;
  bool? get isDeleted => _isDeleted;
  String? get locationId => _locationId;
  Operator? get operator => _operator;
  bool? get isDiscountApplied => _isDiscountApplied;
  num? get discountAmount => _discountAmount;
  num? get tipAmount => _tipAmount;
  String? get notes => _notes;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  List<Payments>? get payments => _payments;
  String? get tableName => _tableName;
  String? get waiterName => _waiterName;
  Invoice? get invoice => _invoice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderNumber'] = _orderNumber;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = _subtotal;
    map['tax'] = _tax;
    map['total'] = _total;
    map['tableNo'] = _tableNo;
    map['waiter'] = _waiter;
    map['orderType'] = _orderType;
    map['orderStatus'] = _orderStatus;
    map['isDeleted'] = _isDeleted;
    map['locationId'] = _locationId;
    if (_operator != null) {
      map['operator'] = _operator?.toJson();
    }
    map['isDiscountApplied'] = _isDiscountApplied;
    map['discountAmount'] = _discountAmount;
    map['tipAmount'] = _tipAmount;
    map['notes'] = _notes;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    if (_payments != null) {
      map['payments'] = _payments?.map((v) => v.toJson()).toList();
    }
    map['tableName'] = _tableName;
    map['waiterName'] = _waiterName;
    if (_invoice != null) {
      map['invoice'] = _invoice?.toJson();
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
/// invoice_items : [{"name":"Chicken Caesar Salad","basePrice":150,"qty":1,"taxPrice":32.4,"totalPrice":212.4,"isAddon":false},{"name":"Toppins","basePrice":0,"qty":1,"taxPrice":0,"totalPrice":0,"isAddon":true,"isFree":false},{"name":"Extra creams","basePrice":30,"qty":1,"taxPrice":5.4,"totalPrice":35.4,"isAddon":true,"isFree":false},{"name":"Greek Salad","basePrice":100,"qty":1,"taxPrice":23.4,"totalPrice":153.4,"isAddon":false},{"name":"Toppins","basePrice":0,"qty":1,"taxPrice":0,"totalPrice":0,"isAddon":true,"isFree":false},{"name":"Extra creams","basePrice":30,"qty":1,"taxPrice":5.4,"totalPrice":35.4,"isAddon":true,"isFree":false}]
/// subtotal : 262.71
/// salesTax : 47.29
/// total : 310
/// orderNumber : "ORD-20250717-0009"
/// date : "7/17/2025, 5:43:09 PM"
/// paidBy : "CARD: ₹310.00"
/// transactionId : "TXN-20250717-362419"
/// tableNum : "1"

class Operator {
  Operator({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? locationId,
    bool? active,
    String? createdAt,
    num? v,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _password = password;
    _role = role;
    _locationId = locationId;
    _active = active;
    _createdAt = createdAt;
    _v = v;
  }

  Operator.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _email = json['email'];
    _password = json['password'];
    _role = json['role'];
    _locationId = json['locationId'];
    _active = json['active'];
    _createdAt = json['createdAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  String? _email;
  String? _password;
  String? _role;
  String? _locationId;
  bool? _active;
  String? _createdAt;
  num? _v;
  Operator copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? locationId,
    bool? active,
    String? createdAt,
    num? v,
  }) =>
      Operator(
        id: id ?? _id,
        name: name ?? _name,
        email: email ?? _email,
        password: password ?? _password,
        role: role ?? _role,
        locationId: locationId ?? _locationId,
        active: active ?? _active,
        createdAt: createdAt ?? _createdAt,
        v: v ?? _v,
      );
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  String? get role => _role;
  String? get locationId => _locationId;
  bool? get active => _active;
  String? get createdAt => _createdAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['password'] = _password;
    map['role'] = _role;
    map['locationId'] = _locationId;
    map['active'] = _active;
    map['createdAt'] = _createdAt;
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
    List<InvoiceItems>? invoiceItems,
    num? subtotal,
    num? salesTax,
    num? total,
    String? orderNumber,
    String? date,
    String? paidBy,
    String? transactionId,
    String? tableNum,
  }) {
    _businessName = businessName;
    _address = address;
    _phone = phone;
    _gstNumber = gstNumber;
    _currencySymbol = currencySymbol;
    _printType = printType;
    _invoiceItems = invoiceItems;
    _subtotal = subtotal;
    _salesTax = salesTax;
    _total = total;
    _orderNumber = orderNumber;
    _date = date;
    _paidBy = paidBy;
    _transactionId = transactionId;
    _tableNum = tableNum;
  }

  Invoice.fromJson(dynamic json) {
    _businessName = json['businessName'];
    _address = json['address'];
    _phone = json['phone'];
    _gstNumber = json['gstNumber'];
    _currencySymbol = json['currencySymbol'];
    _printType = json['printType'];
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
    _date = json['date'];
    _paidBy = json['paidBy'];
    _transactionId = json['transactionId'];
    _tableNum = json['tableNum'];
  }
  String? _businessName;
  String? _address;
  String? _phone;
  String? _gstNumber;
  String? _currencySymbol;
  String? _printType;
  List<InvoiceItems>? _invoiceItems;
  num? _subtotal;
  num? _salesTax;
  num? _total;
  String? _orderNumber;
  String? _date;
  String? _paidBy;
  String? _transactionId;
  String? _tableNum;
  Invoice copyWith({
    String? businessName,
    String? address,
    String? phone,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    List<InvoiceItems>? invoiceItems,
    num? subtotal,
    num? salesTax,
    num? total,
    String? orderNumber,
    String? date,
    String? paidBy,
    String? transactionId,
    String? tableNum,
  }) =>
      Invoice(
        businessName: businessName ?? _businessName,
        address: address ?? _address,
        phone: phone ?? _phone,
        gstNumber: gstNumber ?? _gstNumber,
        currencySymbol: currencySymbol ?? _currencySymbol,
        printType: printType ?? _printType,
        invoiceItems: invoiceItems ?? _invoiceItems,
        subtotal: subtotal ?? _subtotal,
        salesTax: salesTax ?? _salesTax,
        total: total ?? _total,
        orderNumber: orderNumber ?? _orderNumber,
        date: date ?? _date,
        paidBy: paidBy ?? _paidBy,
        transactionId: transactionId ?? _transactionId,
        tableNum: tableNum ?? _tableNum,
      );
  String? get businessName => _businessName;
  String? get address => _address;
  String? get phone => _phone;
  String? get gstNumber => _gstNumber;
  String? get currencySymbol => _currencySymbol;
  String? get printType => _printType;
  List<InvoiceItems>? get invoiceItems => _invoiceItems;
  num? get subtotal => _subtotal;
  num? get salesTax => _salesTax;
  num? get total => _total;
  String? get orderNumber => _orderNumber;
  String? get date => _date;
  String? get paidBy => _paidBy;
  String? get transactionId => _transactionId;
  String? get tableNum => _tableNum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['businessName'] = _businessName;
    map['address'] = _address;
    map['phone'] = _phone;
    map['gstNumber'] = _gstNumber;
    map['currencySymbol'] = _currencySymbol;
    map['printType'] = _printType;
    if (_invoiceItems != null) {
      map['invoice_items'] = _invoiceItems?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = _subtotal;
    map['salesTax'] = _salesTax;
    map['total'] = _total;
    map['orderNumber'] = _orderNumber;
    map['date'] = _date;
    map['paidBy'] = _paidBy;
    map['transactionId'] = _transactionId;
    map['tableNum'] = _tableNum;
    return map;
  }
}

/// name : "Chicken Caesar Salad"
/// basePrice : 150
/// qty : 1
/// taxPrice : 32.4
/// totalPrice : 212.4
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

/// _id : "6878ce4a2d6031682c5deafa"
/// order : "6878ce4a2d6031682c5deae8"
/// paymentMethod : "CARD"
/// amount : 310
/// balanceAmount : 0
/// status : "COMPLETED"
/// createdAt : "2025-07-17T10:19:55.321Z"
/// updatedAt : "2025-07-17T10:19:54.804Z"
/// __v : 0

class Payments {
  Payments({
    String? id,
    String? order,
    String? paymentMethod,
    num? amount,
    num? balanceAmount,
    String? status,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _id = id;
    _order = order;
    _paymentMethod = paymentMethod;
    _amount = amount;
    _balanceAmount = balanceAmount;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  Payments.fromJson(dynamic json) {
    _id = json['_id'];
    _order = json['order'];
    _paymentMethod = json['paymentMethod'];
    _amount = json['amount'];
    _balanceAmount = json['balanceAmount'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _order;
  String? _paymentMethod;
  num? _amount;
  num? _balanceAmount;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  Payments copyWith({
    String? id,
    String? order,
    String? paymentMethod,
    num? amount,
    num? balanceAmount,
    String? status,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      Payments(
        id: id ?? _id,
        order: order ?? _order,
        paymentMethod: paymentMethod ?? _paymentMethod,
        amount: amount ?? _amount,
        balanceAmount: balanceAmount ?? _balanceAmount,
        status: status ?? _status,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  String? get id => _id;
  String? get order => _order;
  String? get paymentMethod => _paymentMethod;
  num? get amount => _amount;
  num? get balanceAmount => _balanceAmount;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['order'] = _order;
    map['paymentMethod'] = _paymentMethod;
    map['amount'] = _amount;
    map['balanceAmount'] = _balanceAmount;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}

/// _id : "6856f9324a333e02a078388c"
/// name : "Saranya"
/// email : "saranyathangarajp@gmail.com"
/// password : "$2b$10$ndxiQMXnqqSotx5zrM49Gug5P9UGGTxF5nDu15j8y/HhOTZR0plym"
/// role : "ADMIN"
/// active : true
/// createdAt : "2025-06-21T18:25:54.879Z"
/// __v : 0

/// product : {"_id":"6856fd1b1544bf146f67685f","name":"Chicken Caesar Salad","category":"6856f9d11544bf146f6767b0","basePrice":150,"hasAddons":true,"image":"https://res.cloudinary.com/dm6wrm7vf/image/upload/v1750531355/products/ojwa1oupzrwo1waj3k5y.jpg","isAvailable":true,"createdBy":"6856f9324a333e02a078388c","createdAt":"2025-06-21T18:42:35.916Z","updatedAt":"2025-06-21T18:42:35.916Z","__v":0}
/// name : "Chicken Caesar Salad"
/// quantity : 1
/// unitPrice : 150
/// addons : [{"addon":{"_id":"6859745aca2dd77aab314117","name":"Toppins","maxQuantity":1,"price":0,"isAvailable":true,"isFree":true,"products":["6856fd1b1544bf146f67685f","6856fd2f1544bf146f676866"],"createdBy":"6856f9324a333e02a078388c","createdAt":"2025-06-23T15:35:54.887Z","updatedAt":"2025-07-16T08:00:41.920Z","__v":0,"category":"6856f9d11544bf146f6767b0"},"name":"Toppins","price":0,"quantity":1,"_id":"6878ce4a2d6031682c5deaea"},{"addon":{"_id":"68763b27ff518ce12520c915","name":"Extra creams","maxQuantity":1,"price":30,"isAvailable":true,"isFree":false,"category":"6856f9d11544bf146f6767b0","products":["6856fd2f1544bf146f676866","6856fd1b1544bf146f67685f"],"createdBy":"6856f9324a333e02a078388c","createdAt":"2025-07-15T11:27:35.991Z","updatedAt":"2025-07-15T11:27:35.991Z","__v":0},"name":"Extra creams","price":30,"quantity":1,"_id":"6878ce4a2d6031682c5deaeb"}]
/// tax : 0
/// subtotal : 180
/// _id : "6878ce4a2d6031682c5deae9"

class Items {
  Items({
    Product? product,
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
    _product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
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
  Product? _product;
  String? _name;
  num? _quantity;
  num? _unitPrice;
  List<Addons>? _addons;
  num? _tax;
  num? _subtotal;
  String? _id;
  Items copyWith({
    Product? product,
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
  Product? get product => _product;
  String? get name => _name;
  num? get quantity => _quantity;
  num? get unitPrice => _unitPrice;
  List<Addons>? get addons => _addons;
  num? get tax => _tax;
  num? get subtotal => _subtotal;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
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

/// addon : {"_id":"6859745aca2dd77aab314117","name":"Toppins","maxQuantity":1,"price":0,"isAvailable":true,"isFree":true,"products":["6856fd1b1544bf146f67685f","6856fd2f1544bf146f676866"],"createdBy":"6856f9324a333e02a078388c","createdAt":"2025-06-23T15:35:54.887Z","updatedAt":"2025-07-16T08:00:41.920Z","__v":0,"category":"6856f9d11544bf146f6767b0"}
/// name : "Toppins"
/// price : 0
/// quantity : 1
/// _id : "6878ce4a2d6031682c5deaea"

class Addons {
  Addons({
    Addon? addon,
    String? name,
    num? price,
    num? quantity,
    String? id,
  }) {
    _addon = addon;
    _name = name;
    _price = price;
    _quantity = quantity;
    _id = id;
  }

  Addons.fromJson(dynamic json) {
    _addon = json['addon'] != null ? Addon.fromJson(json['addon']) : null;
    _name = json['name'];
    _price = json['price'];
    _quantity = json['quantity'];
    _id = json['_id'];
  }
  Addon? _addon;
  String? _name;
  num? _price;
  num? _quantity;
  String? _id;
  Addons copyWith({
    Addon? addon,
    String? name,
    num? price,
    num? quantity,
    String? id,
  }) =>
      Addons(
        addon: addon ?? _addon,
        name: name ?? _name,
        price: price ?? _price,
        quantity: quantity ?? _quantity,
        id: id ?? _id,
      );
  Addon? get addon => _addon;
  String? get name => _name;
  num? get price => _price;
  num? get quantity => _quantity;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_addon != null) {
      map['addon'] = _addon?.toJson();
    }
    map['name'] = _name;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['_id'] = _id;
    return map;
  }
}

/// _id : "6859745aca2dd77aab314117"
/// name : "Toppins"
/// maxQuantity : 1
/// price : 0
/// isAvailable : true
/// isFree : true
/// products : ["6856fd1b1544bf146f67685f","6856fd2f1544bf146f676866"]
/// createdBy : "6856f9324a333e02a078388c"
/// createdAt : "2025-06-23T15:35:54.887Z"
/// updatedAt : "2025-07-16T08:00:41.920Z"
/// __v : 0
/// category : "6856f9d11544bf146f6767b0"

class Addon {
  Addon({
    String? id,
    String? name,
    num? maxQuantity,
    num? price,
    bool? isAvailable,
    bool? isFree,
    List<String>? products,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
    String? category,
  }) {
    _id = id;
    _name = name;
    _maxQuantity = maxQuantity;
    _price = price;
    _isAvailable = isAvailable;
    _isFree = isFree;
    _products = products;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _category = category;
  }

  Addon.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _maxQuantity = json['maxQuantity'];
    _price = json['price'];
    _isAvailable = json['isAvailable'];
    _isFree = json['isFree'];
    _products = json['products'] != null ? json['products'].cast<String>() : [];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _category = json['category'];
  }
  String? _id;
  String? _name;
  num? _maxQuantity;
  num? _price;
  bool? _isAvailable;
  bool? _isFree;
  List<String>? _products;
  String? _createdBy;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _category;
  Addon copyWith({
    String? id,
    String? name,
    num? maxQuantity,
    num? price,
    bool? isAvailable,
    bool? isFree,
    List<String>? products,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
    String? category,
  }) =>
      Addon(
        id: id ?? _id,
        name: name ?? _name,
        maxQuantity: maxQuantity ?? _maxQuantity,
        price: price ?? _price,
        isAvailable: isAvailable ?? _isAvailable,
        isFree: isFree ?? _isFree,
        products: products ?? _products,
        createdBy: createdBy ?? _createdBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
        category: category ?? _category,
      );
  String? get id => _id;
  String? get name => _name;
  num? get maxQuantity => _maxQuantity;
  num? get price => _price;
  bool? get isAvailable => _isAvailable;
  bool? get isFree => _isFree;
  List<String>? get products => _products;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  String? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['maxQuantity'] = _maxQuantity;
    map['price'] = _price;
    map['isAvailable'] = _isAvailable;
    map['isFree'] = _isFree;
    map['products'] = _products;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['category'] = _category;
    return map;
  }
}

/// _id : "6856fd1b1544bf146f67685f"
/// name : "Chicken Caesar Salad"
/// category : "6856f9d11544bf146f6767b0"
/// basePrice : 150
/// hasAddons : true
/// image : "https://res.cloudinary.com/dm6wrm7vf/image/upload/v1750531355/products/ojwa1oupzrwo1waj3k5y.jpg"
/// isAvailable : true
/// createdBy : "6856f9324a333e02a078388c"
/// createdAt : "2025-06-21T18:42:35.916Z"
/// updatedAt : "2025-06-21T18:42:35.916Z"
/// __v : 0

class Product {
  Product({
    String? id,
    String? name,
    String? category,
    num? basePrice,
    bool? hasAddons,
    String? image,
    bool? isAvailable,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _id = id;
    _name = name;
    _category = category;
    _basePrice = basePrice;
    _hasAddons = hasAddons;
    _image = image;
    _isAvailable = isAvailable;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  Product.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _category = json['category'];
    _basePrice = json['basePrice'];
    _hasAddons = json['hasAddons'];
    _image = json['image'];
    _isAvailable = json['isAvailable'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  String? _category;
  num? _basePrice;
  bool? _hasAddons;
  String? _image;
  bool? _isAvailable;
  String? _createdBy;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  Product copyWith({
    String? id,
    String? name,
    String? category,
    num? basePrice,
    bool? hasAddons,
    String? image,
    bool? isAvailable,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      Product(
        id: id ?? _id,
        name: name ?? _name,
        category: category ?? _category,
        basePrice: basePrice ?? _basePrice,
        hasAddons: hasAddons ?? _hasAddons,
        image: image ?? _image,
        isAvailable: isAvailable ?? _isAvailable,
        createdBy: createdBy ?? _createdBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  String? get id => _id;
  String? get name => _name;
  String? get category => _category;
  num? get basePrice => _basePrice;
  bool? get hasAddons => _hasAddons;
  String? get image => _image;
  bool? get isAvailable => _isAvailable;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['category'] = _category;
    map['basePrice'] = _basePrice;
    map['hasAddons'] = _hasAddons;
    map['image'] = _image;
    map['isAvailable'] = _isAvailable;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}
