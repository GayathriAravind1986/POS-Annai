import 'package:simple/Bloc/Response/errorResponse.dart';

/// success : true
/// data : {"location":{"address":"Tenkasi main road","city":"Alangualam","state":"Tamil Nadu","zipCode":"627851","country":"India"},"_id":"68902eb61432ba566a420059","name":"Alagu Drive In","contactNumber":"+91 0000000000","email":"admin@gmail.com","gstNumber":"00000000000","currencySymbol":"₹","printType":"imin","tipEnabled":false,"createdAt":"2025-08-04T03:53:26.419Z","__v":0,"stockMaintenance":true}

class GetStockMaintanencesModel {
  GetStockMaintanencesModel({
    bool? success,
    Data? data,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
  }

  GetStockMaintanencesModel.fromJson(dynamic json) {
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
  GetStockMaintanencesModel copyWith({
    bool? success,
    Data? data,
  }) =>
      GetStockMaintanencesModel(
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

/// location : {"address":"Tenkasi main road","city":"Alangualam","state":"Tamil Nadu","zipCode":"627851","country":"India"}
/// _id : "68902eb61432ba566a420059"
/// name : "Alagu Drive In"
/// contactNumber : "+91 0000000000"
/// email : "admin@gmail.com"
/// gstNumber : "00000000000"
/// currencySymbol : "₹"
/// printType : "imin"
/// tipEnabled : false
/// createdAt : "2025-08-04T03:53:26.419Z"
/// __v : 0
/// stockMaintenance : true

class Data {
  Data({
    Location? location,
    String? id,
    String? name,
    String? contactNumber,
    String? email,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    bool? tipEnabled,
    bool? stockMaintenance,
    String? createdAt,
    num? v,
    String? logo,
    String? image,
  }) {
    _location = location;
    _id = id;
    _name = name;
    _contactNumber = contactNumber;
    _email = email;
    _gstNumber = gstNumber;
    _currencySymbol = currencySymbol;
    _printType = printType;
    _tipEnabled = tipEnabled;
    _stockMaintenance = stockMaintenance;
    _createdAt = createdAt;
    _v = v;
    _logo = logo;
    _image = image;
  }

  Data.fromJson(dynamic json) {
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _id = json['_id'];
    _name = json['name'];
    _contactNumber = json['contactNumber'];
    _email = json['email'];
    _gstNumber = json['gstNumber'];
    _currencySymbol = json['currencySymbol'];
    _printType = json['printType'];
    _tipEnabled = json['tipEnabled'];
    _stockMaintenance = json['stockMaintenance'];
    _createdAt = json['createdAt'];
    _v = json['__v'];
    _logo = json['logo'];
    _image = json['image'];
  }
  Location? _location;
  String? _id;
  String? _name;
  String? _contactNumber;
  String? _email;
  String? _gstNumber;
  String? _currencySymbol;
  String? _printType;
  bool? _tipEnabled;
  bool? _stockMaintenance;
  String? _createdAt;
  num? _v;
  String? _logo;
  String? _image;
  Data copyWith({
    Location? location,
    String? id,
    String? name,
    String? contactNumber,
    String? email,
    String? gstNumber,
    String? currencySymbol,
    String? printType,
    bool? tipEnabled,
    bool? stockMaintenance,
    String? createdAt,
    num? v,
    String? logo,
    String? image,
  }) =>
      Data(
        location: location ?? _location,
        id: id ?? _id,
        name: name ?? _name,
        contactNumber: contactNumber ?? _contactNumber,
        email: email ?? _email,
        gstNumber: gstNumber ?? _gstNumber,
        currencySymbol: currencySymbol ?? _currencySymbol,
        printType: printType ?? _printType,
        tipEnabled: tipEnabled ?? _tipEnabled,
        stockMaintenance: stockMaintenance ?? _stockMaintenance,
        createdAt: createdAt ?? _createdAt,
        v: v ?? _v,
        logo: logo ?? _logo,
        image: image ?? _image,
      );
  Location? get location => _location;
  String? get id => _id;
  String? get name => _name;
  String? get contactNumber => _contactNumber;
  String? get email => _email;
  String? get gstNumber => _gstNumber;
  String? get currencySymbol => _currencySymbol;
  String? get printType => _printType;
  bool? get tipEnabled => _tipEnabled;
  bool? get stockMaintenance => _stockMaintenance;
  String? get createdAt => _createdAt;
  num? get v => _v;
  String? get logo => _logo;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    map['_id'] = _id;
    map['name'] = _name;
    map['contactNumber'] = _contactNumber;
    map['email'] = _email;
    map['gstNumber'] = _gstNumber;
    map['currencySymbol'] = _currencySymbol;
    map['printType'] = _printType;
    map['tipEnabled'] = _tipEnabled;
    map['stockMaintenance'] = _stockMaintenance;
    map['createdAt'] = _createdAt;
    map['__v'] = _v;
    map['logo'] = _logo;
    map['image'] = _image;
    return map;
  }
}

/// address : "Tenkasi main road"
/// city : "Alangualam"
/// state : "Tamil Nadu"
/// zipCode : "627851"
/// country : "India"

class Location {
  Location({
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    _address = address;
    _city = city;
    _state = state;
    _zipCode = zipCode;
    _country = country;
  }

  Location.fromJson(dynamic json) {
    _address = json['address'];
    _city = json['city'];
    _state = json['state'];
    _zipCode = json['zipCode'];
    _country = json['country'];
  }
  String? _address;
  String? _city;
  String? _state;
  String? _zipCode;
  String? _country;
  Location copyWith({
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) =>
      Location(
        address: address ?? _address,
        city: city ?? _city,
        state: state ?? _state,
        zipCode: zipCode ?? _zipCode,
        country: country ?? _country,
      );
  String? get address => _address;
  String? get city => _city;
  String? get state => _state;
  String? get zipCode => _zipCode;
  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['city'] = _city;
    map['state'] = _state;
    map['zipCode'] = _zipCode;
    map['country'] = _country;
    return map;
  }
}
