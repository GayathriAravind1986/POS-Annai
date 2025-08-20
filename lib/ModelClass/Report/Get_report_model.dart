import 'package:simple/Bloc/Response/errorResponse.dart';

/// success : true
/// data : [{"productId":{"sortOrder":0,"_id":"68905ba7f7a56be2b7655196","name":"Egg Briyani","category":"68905b61f7a56be2b7655158","basePrice":150,"hasAddons":true,"image":"https://res.cloudinary.com/dm6wrm7vf/image/upload/v1754291110/products/zv3ewtdoefyqlmvplqi6.webp","dailyStockClear":false,"isDefault":true,"locationId":"68903a7bf7a56be2b7654f2f","createdBy":"6890315266eb7a8181a3b4b4","createdAt":"2025-08-04T07:05:11.576Z","updatedAt":"2025-08-07T07:00:19.189Z","__v":0},"productName":"Egg Briyani","unitPrice":150,"totalQty":2,"totalTax":0,"totalAmount":300}]
/// totalRecords : 1
/// offset : 0
/// limit : 200
/// finalAmount : 300
/// finalQty : 2
/// UserName : "Counter1"
/// businessName : "Alagu Drive In"
/// address : "Tenkasi main road, Alangualam, Tamil Nadu 627851"
/// phone : "+91 0000000000"
/// gstNumber : "00000000000"
/// currencySymbol : "₹"
/// printType : "imin"

class GetReportModel {
  GetReportModel({
    bool? success,
    List<Data>? data,
    num? totalRecords,
    num? offset,
    num? limit,
    num? finalAmount,
    num? finalQty,
    String? userName,
    String? location,
    String? fromDate,
    String? toDate,
    String? businessName,
    String? address,
    String? phone,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
    _totalRecords = totalRecords;
    _offset = offset;
    _limit = limit;
    _finalAmount = finalAmount;
    _finalQty = finalQty;
    _userName = userName;
    _location = location;
    _fromDate = fromDate;
    _toDate = toDate;
    _businessName = businessName;
    _address = address;
    _phone = phone;
    _gstNumber = gstNumber;
    _currencySymbol = currencySymbol;
    _printType = printType;
  }

  GetReportModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _totalRecords = json['totalRecords'];
    _offset = json['offset'];
    _limit = json['limit'];
    _finalAmount = json['finalAmount'];
    _finalQty = json['finalQty'];
    _userName = json['UserName'];
    _location = json['location'];
    _fromDate = json['from_date'];
    _toDate = json['to_date'];
    _businessName = json['businessName'];
    _address = json['address'];
    _phone = json['phone'];
    _gstNumber = json['gstNumber'];
    _currencySymbol = json['currencySymbol'];
    _printType = json['printType'];
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  List<Data>? _data;
  num? _totalRecords;
  num? _offset;
  num? _limit;
  num? _finalAmount;
  num? _finalQty;
  String? _userName;
  String? _location;
  String? _fromDate;
  String? _toDate;
  String? _businessName;
  String? _address;
  String? _phone;
  String? _gstNumber;
  String? _currencySymbol;
  String? _printType;
  ErrorResponse? errorResponse;
  GetReportModel copyWith({
    bool? success,
    List<Data>? data,
    num? totalRecords,
    num? offset,
    num? limit,
    num? finalAmount,
    num? finalQty,
    String? userName,
    String? location,
    String? fromDate,
    String? toDate,
    String? businessName,
    String? address,
    String? phone,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
  }) =>
      GetReportModel(
        success: success ?? _success,
        data: data ?? _data,
        totalRecords: totalRecords ?? _totalRecords,
        offset: offset ?? _offset,
        limit: limit ?? _limit,
        finalAmount: finalAmount ?? _finalAmount,
        finalQty: finalQty ?? _finalQty,
        userName: userName ?? _userName,
        location: location ?? _location,
        fromDate: fromDate ?? _fromDate,
        toDate: toDate ?? _toDate,
        businessName: businessName ?? _businessName,
        address: address ?? _address,
        phone: phone ?? _phone,
        gstNumber: gstNumber ?? _gstNumber,
        currencySymbol: currencySymbol ?? _currencySymbol,
        printType: printType ?? _printType,
      );
  bool? get success => _success;
  List<Data>? get data => _data;
  num? get totalRecords => _totalRecords;
  num? get offset => _offset;
  num? get limit => _limit;
  num? get finalAmount => _finalAmount;
  num? get finalQty => _finalQty;
  String? get userName => _userName;
  String? get location => _location;
  String? get fromDate => _fromDate;
  String? get toDate => _toDate;
  String? get businessName => _businessName;
  String? get address => _address;
  String? get phone => _phone;
  String? get gstNumber => _gstNumber;
  String? get currencySymbol => _currencySymbol;
  String? get printType => _printType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['totalRecords'] = _totalRecords;
    map['offset'] = _offset;
    map['limit'] = _limit;
    map['finalAmount'] = _finalAmount;
    map['finalQty'] = _finalQty;
    map['UserName'] = _userName;
    map['location'] = _location;
    map['from_date'] = _fromDate;
    map['to_date'] = _toDate;
    map['businessName'] = _businessName;
    map['address'] = _address;
    map['phone'] = _phone;
    map['gstNumber'] = _gstNumber;
    map['currencySymbol'] = _currencySymbol;
    map['printType'] = _printType;
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// productId : {"sortOrder":0,"_id":"68905ba7f7a56be2b7655196","name":"Egg Briyani","category":"68905b61f7a56be2b7655158","basePrice":150,"hasAddons":true,"image":"https://res.cloudinary.com/dm6wrm7vf/image/upload/v1754291110/products/zv3ewtdoefyqlmvplqi6.webp","dailyStockClear":false,"isDefault":true,"locationId":"68903a7bf7a56be2b7654f2f","createdBy":"6890315266eb7a8181a3b4b4","createdAt":"2025-08-04T07:05:11.576Z","updatedAt":"2025-08-07T07:00:19.189Z","__v":0}
/// productName : "Egg Briyani"
/// unitPrice : 150
/// totalQty : 2
/// totalTax : 0
/// totalAmount : 300

class Data {
  Data({
    ProductId? productId,
    String? productName,
    num? unitPrice,
    num? totalQty,
    num? totalTax,
    num? totalAmount,
  }) {
    _productId = productId;
    _productName = productName;
    _unitPrice = unitPrice;
    _totalQty = totalQty;
    _totalTax = totalTax;
    _totalAmount = totalAmount;
  }

  Data.fromJson(dynamic json) {
    _productId = json['productId'] != null
        ? ProductId.fromJson(json['productId'])
        : null;
    _productName = json['productName'];
    _unitPrice = json['unitPrice'];
    _totalQty = json['totalQty'];
    _totalTax = json['totalTax'];
    _totalAmount = json['totalAmount'];
  }
  ProductId? _productId;
  String? _productName;
  num? _unitPrice;
  num? _totalQty;
  num? _totalTax;
  num? _totalAmount;
  Data copyWith({
    ProductId? productId,
    String? productName,
    num? unitPrice,
    num? totalQty,
    num? totalTax,
    num? totalAmount,
  }) =>
      Data(
        productId: productId ?? _productId,
        productName: productName ?? _productName,
        unitPrice: unitPrice ?? _unitPrice,
        totalQty: totalQty ?? _totalQty,
        totalTax: totalTax ?? _totalTax,
        totalAmount: totalAmount ?? _totalAmount,
      );
  ProductId? get productId => _productId;
  String? get productName => _productName;
  num? get unitPrice => _unitPrice;
  num? get totalQty => _totalQty;
  num? get totalTax => _totalTax;
  num? get totalAmount => _totalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_productId != null) {
      map['productId'] = _productId?.toJson();
    }
    map['productName'] = _productName;
    map['unitPrice'] = _unitPrice;
    map['totalQty'] = _totalQty;
    map['totalTax'] = _totalTax;
    map['totalAmount'] = _totalAmount;
    return map;
  }
}

/// sortOrder : 0
/// _id : "68905ba7f7a56be2b7655196"
/// name : "Egg Briyani"
/// category : "68905b61f7a56be2b7655158"
/// basePrice : 150
/// hasAddons : true
/// image : "https://res.cloudinary.com/dm6wrm7vf/image/upload/v1754291110/products/zv3ewtdoefyqlmvplqi6.webp"
/// dailyStockClear : false
/// isDefault : true
/// locationId : "68903a7bf7a56be2b7654f2f"
/// createdBy : "6890315266eb7a8181a3b4b4"
/// createdAt : "2025-08-04T07:05:11.576Z"
/// updatedAt : "2025-08-07T07:00:19.189Z"
/// __v : 0

class ProductId {
  ProductId({
    num? sortOrder,
    String? id,
    String? name,
    String? category,
    num? basePrice,
    bool? hasAddons,
    String? image,
    bool? dailyStockClear,
    bool? isDefault,
    String? locationId,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _sortOrder = sortOrder;
    _id = id;
    _name = name;
    _category = category;
    _basePrice = basePrice;
    _hasAddons = hasAddons;
    _image = image;
    _dailyStockClear = dailyStockClear;
    _isDefault = isDefault;
    _locationId = locationId;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  ProductId.fromJson(dynamic json) {
    _sortOrder = json['sortOrder'];
    _id = json['_id'];
    _name = json['name'];
    _category = json['category'];
    _basePrice = json['basePrice'];
    _hasAddons = json['hasAddons'];
    _image = json['image'];
    _dailyStockClear = json['dailyStockClear'];
    _isDefault = json['isDefault'];
    _locationId = json['locationId'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  num? _sortOrder;
  String? _id;
  String? _name;
  String? _category;
  num? _basePrice;
  bool? _hasAddons;
  String? _image;
  bool? _dailyStockClear;
  bool? _isDefault;
  String? _locationId;
  String? _createdBy;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  ProductId copyWith({
    num? sortOrder,
    String? id,
    String? name,
    String? category,
    num? basePrice,
    bool? hasAddons,
    String? image,
    bool? dailyStockClear,
    bool? isDefault,
    String? locationId,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      ProductId(
        sortOrder: sortOrder ?? _sortOrder,
        id: id ?? _id,
        name: name ?? _name,
        category: category ?? _category,
        basePrice: basePrice ?? _basePrice,
        hasAddons: hasAddons ?? _hasAddons,
        image: image ?? _image,
        dailyStockClear: dailyStockClear ?? _dailyStockClear,
        isDefault: isDefault ?? _isDefault,
        locationId: locationId ?? _locationId,
        createdBy: createdBy ?? _createdBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  num? get sortOrder => _sortOrder;
  String? get id => _id;
  String? get name => _name;
  String? get category => _category;
  num? get basePrice => _basePrice;
  bool? get hasAddons => _hasAddons;
  String? get image => _image;
  bool? get dailyStockClear => _dailyStockClear;
  bool? get isDefault => _isDefault;
  String? get locationId => _locationId;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sortOrder'] = _sortOrder;
    map['_id'] = _id;
    map['name'] = _name;
    map['category'] = _category;
    map['basePrice'] = _basePrice;
    map['hasAddons'] = _hasAddons;
    map['image'] = _image;
    map['dailyStockClear'] = _dailyStockClear;
    map['isDefault'] = _isDefault;
    map['locationId'] = _locationId;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}
