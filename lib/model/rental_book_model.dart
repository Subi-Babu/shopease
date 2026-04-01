// To parse this JSON data, do
//
//     final rentalBookListModel = rentalBookListModelFromJson(jsonString);

import 'dart:convert';

RentalBookListModel rentalBookListModelFromJson(String str) => RentalBookListModel.fromJson(json.decode(str));

String rentalBookListModelToJson(RentalBookListModel data) => json.encode(data.toJson());

class RentalBookListModel {
  bool? status;
  String? message;
  List<Datum>? data;

  RentalBookListModel({
    this.status,
    this.message,
    this.data,
  });

  factory RentalBookListModel.fromJson(Map<String, dynamic> json) => RentalBookListModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? rentalBookingId;
  int? userId;
  int? rentalServiceId;
  dynamic storeId;
  int? userAddressId;
  String? name;
  String? code;
  String? phoneNumber;
  DateTime? date;
  String? message;
  String? status;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic projectId;
  dynamic projects;
  RentalService? rentalService;
  Users? users;
  UserAddress? userAddress;
  dynamic store;

  Datum({
    this.id,
    this.rentalBookingId,
    this.userId,
    this.rentalServiceId,
    this.storeId,
    this.userAddressId,
    this.name,
    this.code,
    this.phoneNumber,
    this.date,
    this.message,
    this.status,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.projectId,
    this.projects,
    this.rentalService,
    this.users,
    this.userAddress,
    this.store,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    rentalBookingId: json["rentalBookingId"],
    userId: json["userId"],
    rentalServiceId: json["rentalServiceId"],
    storeId: json["storeId"],
    userAddressId: json["userAddressId"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    message: json["message"],
    status: json["status"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    projectId: json["projectId"],
    projects: json["projects"],
    rentalService: json["rentalService"] == null ? null : RentalService.fromJson(json["rentalService"]),
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    userAddress: json["userAddress"] == null ? null : UserAddress.fromJson(json["userAddress"]),
    store: json["store"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rentalBookingId": rentalBookingId,
    "userId": userId,
    "rentalServiceId": rentalServiceId,
    "storeId": storeId,
    "userAddressId": userAddressId,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
    "date": date?.toIso8601String(),
    "message": message,
    "status": status,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "projectId": projectId,
    "projects": projects,
    "rentalService": rentalService?.toJson(),
    "users": users?.toJson(),
    "userAddress": userAddress?.toJson(),
    "store": store,
  };
}

class RentalService {
  int? id;
  String? name;
  String? image;

  RentalService({
    this.id,
    this.name,
    this.image,
  });

  factory RentalService.fromJson(Map<String, dynamic> json) => RentalService(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "Image": image,
  };
}

class UserAddress {
  int? id;
  int? userId;
  String? address;
  String? addressTitle;
  int? pinCode;
  String? location;
  String? name;
  String? phoneNumber;
  String? code;
  dynamic countryId;
  dynamic zoneId;
  dynamic clusterId;
  dynamic stateId;
  dynamic districtId;
  bool? isActive;
  bool? isDelete;
  bool? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserAddress({
    this.id,
    this.userId,
    this.address,
    this.addressTitle,
    this.pinCode,
    this.location,
    this.name,
    this.phoneNumber,
    this.code,
    this.countryId,
    this.zoneId,
    this.clusterId,
    this.stateId,
    this.districtId,
    this.isActive,
    this.isDelete,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
    id: json["id"],
    userId: json["userId"],
    address: json["address"],
    addressTitle: json["addressTitle"],
    pinCode: json["pinCode"],
    location: json["location"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    code: json["code"],
    countryId: json["countryId"],
    zoneId: json["zoneId"],
    clusterId: json["clusterId"],
    stateId: json["stateId"],
    districtId: json["districtId"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    isDefault: json["isDefault"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "address": address,
    "addressTitle": addressTitle,
    "pinCode": pinCode,
    "location": location,
    "name": name,
    "phoneNumber": phoneNumber,
    "code": code,
    "countryId": countryId,
    "zoneId": zoneId,
    "clusterId": clusterId,
    "stateId": stateId,
    "districtId": districtId,
    "isActive": isActive,
    "isDelete": isDelete,
    "isDefault": isDefault,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Users {
  int? id;
  String? name;
  String? code;
  String? phoneNumber;

  Users({
    this.id,
    this.name,
    this.code,
    this.phoneNumber,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
  };
}
