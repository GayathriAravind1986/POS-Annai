import 'package:simple/Bloc/Response/errorResponse.dart';

/// success : true
/// data : [{"_id":"68a6a579c62002064976c7bc","name":"Counter2","email":"counter2@gmail.com","role":"OPERATOR","locationId":{"_id":"68a6a493c62002064976c72a","name":"Rajapalayam","description":"R","sortOrder":0,"setDefault":true,"isDefault":true,"createdBy":"68a5f98887951e920ca22530","createdAt":"2025-08-21T04:46:11.583Z","updatedAt":"2025-08-21T04:46:11.583Z","__v":0},"active":true,"createdAt":"2025-08-21T04:50:01.787Z","__v":0},{"_id":"68a6a569c62002064976c7b4","name":"Counter1","email":"counter1@gmail.com","role":"OPERATOR","locationId":{"_id":"68a6a493c62002064976c72a","name":"Rajapalayam","description":"R","sortOrder":0,"setDefault":true,"isDefault":true,"createdBy":"68a5f98887951e920ca22530","createdAt":"2025-08-21T04:46:11.583Z","updatedAt":"2025-08-21T04:46:11.583Z","__v":0},"active":true,"createdAt":"2025-08-21T04:49:45.966Z","__v":0}]
/// totalCount : 2

class GetUserModel {
  GetUserModel({
    bool? success,
    List<Data>? data,
    num? totalCount,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
    _totalCount = totalCount;
  }

  GetUserModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _totalCount = json['totalCount'];
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  List<Data>? _data;
  num? _totalCount;
  ErrorResponse? errorResponse;
  GetUserModel copyWith({
    bool? success,
    List<Data>? data,
    num? totalCount,
  }) =>
      GetUserModel(
        success: success ?? _success,
        data: data ?? _data,
        totalCount: totalCount ?? _totalCount,
      );
  bool? get success => _success;
  List<Data>? get data => _data;
  num? get totalCount => _totalCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['totalCount'] = _totalCount;
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// _id : "68a6a579c62002064976c7bc"
/// name : "Counter2"
/// email : "counter2@gmail.com"
/// role : "OPERATOR"
/// locationId : {"_id":"68a6a493c62002064976c72a","name":"Rajapalayam","description":"R","sortOrder":0,"setDefault":true,"isDefault":true,"createdBy":"68a5f98887951e920ca22530","createdAt":"2025-08-21T04:46:11.583Z","updatedAt":"2025-08-21T04:46:11.583Z","__v":0}
/// active : true
/// createdAt : "2025-08-21T04:50:01.787Z"
/// __v : 0

class Data {
  Data({
    String? id,
    String? name,
    String? email,
    String? role,
    LocationId? locationId,
    bool? active,
    String? createdAt,
    num? v,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _role = role;
    _locationId = locationId;
    _active = active;
    _createdAt = createdAt;
    _v = v;
  }

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _email = json['email'];
    _role = json['role'];
    _locationId = json['locationId'] != null
        ? LocationId.fromJson(json['locationId'])
        : null;
    _active = json['active'];
    _createdAt = json['createdAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  String? _email;
  String? _role;
  LocationId? _locationId;
  bool? _active;
  String? _createdAt;
  num? _v;
  Data copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    LocationId? locationId,
    bool? active,
    String? createdAt,
    num? v,
  }) =>
      Data(
        id: id ?? _id,
        name: name ?? _name,
        email: email ?? _email,
        role: role ?? _role,
        locationId: locationId ?? _locationId,
        active: active ?? _active,
        createdAt: createdAt ?? _createdAt,
        v: v ?? _v,
      );
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get role => _role;
  LocationId? get locationId => _locationId;
  bool? get active => _active;
  String? get createdAt => _createdAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['role'] = _role;
    if (_locationId != null) {
      map['locationId'] = _locationId?.toJson();
    }
    map['active'] = _active;
    map['createdAt'] = _createdAt;
    map['__v'] = _v;
    return map;
  }
}

/// _id : "68a6a493c62002064976c72a"
/// name : "Rajapalayam"
/// description : "R"
/// sortOrder : 0
/// setDefault : true
/// isDefault : true
/// createdBy : "68a5f98887951e920ca22530"
/// createdAt : "2025-08-21T04:46:11.583Z"
/// updatedAt : "2025-08-21T04:46:11.583Z"
/// __v : 0

class LocationId {
  LocationId({
    String? id,
    String? name,
    String? description,
    num? sortOrder,
    bool? setDefault,
    bool? isDefault,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _sortOrder = sortOrder;
    _setDefault = setDefault;
    _isDefault = isDefault;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  LocationId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _description = json['description'];
    _sortOrder = json['sortOrder'];
    _setDefault = json['setDefault'];
    _isDefault = json['isDefault'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  String? _description;
  num? _sortOrder;
  bool? _setDefault;
  bool? _isDefault;
  String? _createdBy;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  LocationId copyWith({
    String? id,
    String? name,
    String? description,
    num? sortOrder,
    bool? setDefault,
    bool? isDefault,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      LocationId(
        id: id ?? _id,
        name: name ?? _name,
        description: description ?? _description,
        sortOrder: sortOrder ?? _sortOrder,
        setDefault: setDefault ?? _setDefault,
        isDefault: isDefault ?? _isDefault,
        createdBy: createdBy ?? _createdBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  num? get sortOrder => _sortOrder;
  bool? get setDefault => _setDefault;
  bool? get isDefault => _isDefault;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['sortOrder'] = _sortOrder;
    map['setDefault'] = _setDefault;
    map['isDefault'] = _isDefault;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}
