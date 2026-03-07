// To parse this JSON data, do
//
//     final addressListModel = addressListModelFromJson(jsonString);

import 'dart:convert';

AddressListModel addressListModelFromJson(String str) => AddressListModel.fromJson(json.decode(str));

String addressListModelToJson(AddressListModel data) => json.encode(data.toJson());

class AddressListModel {
  bool? status;
  String? message;
  int? page;
  int? totalPages;
  int? totalUserAddress;
  List<Datum>? data;

  AddressListModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.totalUserAddress,
    this.data,
  });

  factory AddressListModel.fromJson(Map<String, dynamic> json) => AddressListModel(
    status: json["status"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    totalUserAddress: json["totalUserAddress"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "totalUserAddress": totalUserAddress,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? address;
  String? addressTitle;
  int? pinCode;
  String? location;
  String? name;
  String? code;
  String? phoneNumber;
  bool? isDefault;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  Datum({
    this.id,
    this.address,
    this.addressTitle,
    this.pinCode,
    this.location,
    this.name,
    this.code,
    this.phoneNumber,
    this.isDefault,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    address: json["address"],
    addressTitle: json["addressTitle"],
    pinCode: json["pinCode"],
    location: json["location"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    isDefault: json["isDefault"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "addressTitle": addressTitle,
    "pinCode": pinCode,
    "location": location,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
    "isDefault": isDefault,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}
