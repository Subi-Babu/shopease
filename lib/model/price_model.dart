// To parse this JSON data, do
//
//     final priceModel = priceModelFromJson(jsonString);

import 'dart:convert';

PriceModel priceModelFromJson(String str) => PriceModel.fromJson(json.decode(str));

String priceModelToJson(PriceModel data) => json.encode(data.toJson());

class PriceModel {
  bool? status;
  String? message;
  Data? data;

  PriceModel({
    this.status,
    this.message,
    this.data,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  dynamic projectId;
  dynamic project;
  dynamic grandTotal;
  int? userAddressId;
  UserAddress? userAddress;
  dynamic totalGst;

  Data({
    this.id,
    this.projectId,
    this.project,
    this.grandTotal,
    this.userAddressId,
    this.userAddress,
    this.totalGst,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    projectId: json["projectId"],
    project: json["project"],
    grandTotal: json["grandTotal"],
    userAddressId: json["userAddressId"],
    userAddress: json["userAddress"] == null ? null : UserAddress.fromJson(json["userAddress"]),
    totalGst: json["TotalGst"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "projectId": projectId,
    "project": project,
    "grandTotal": grandTotal,
    "userAddressId": userAddressId,
    "userAddress": userAddress?.toJson(),
    "TotalGst": totalGst,
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
  dynamic code;
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
