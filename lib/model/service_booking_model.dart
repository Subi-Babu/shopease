// To parse this JSON data, do
//
//     final serviceBookingModel = serviceBookingModelFromJson(jsonString);

import 'dart:convert';

ServiceBookingModel serviceBookingModelFromJson(String str) => ServiceBookingModel.fromJson(json.decode(str));

String serviceBookingModelToJson(ServiceBookingModel data) => json.encode(data.toJson());

class ServiceBookingModel {
  bool? status;
  String? message;
  List<Datum>? data;

  ServiceBookingModel({
    this.status,
    this.message,
    this.data,
  });

  factory ServiceBookingModel.fromJson(Map<String, dynamic> json) => ServiceBookingModel(
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
  String? serviceBookingId;
  int? userId;
  int? serviceId;
  dynamic serviceHubId;
  int? userAddressId;
  String? name;
  String? code;
  String? phoneNumber;
  DateTime? date;
  dynamic message;
  String? fileName;
  String? file;
  int? size;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.serviceBookingId,
    this.userId,
    this.serviceId,
    this.serviceHubId,
    this.userAddressId,
    this.name,
    this.code,
    this.phoneNumber,
    this.date,
    this.message,
    this.fileName,
    this.file,
    this.size,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    serviceBookingId: json["serviceBookingId"],
    userId: json["userId"],
    serviceId: json["serviceId"],
    serviceHubId: json["serviceHubId"],
    userAddressId: json["userAddressId"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    message: json["message"],
    fileName: json["fileName"],
    file: json["file"],
    size: json["size"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceBookingId": serviceBookingId,
    "userId": userId,
    "serviceId": serviceId,
    "serviceHubId": serviceHubId,
    "userAddressId": userAddressId,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
    "date": date?.toIso8601String(),
    "message": message,
    "fileName": fileName,
    "file": file,
    "size": size,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
