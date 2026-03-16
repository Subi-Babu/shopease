// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  bool? status;
  String? message;
  int? page;
  int? totalPages;
  List<ServiceList>? serviceList;

  ServiceModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.serviceList,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    status: json["status"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    serviceList: json["ServiceList"] == null ? [] : List<ServiceList>.from(json["ServiceList"]!.map((x) => ServiceList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "ServiceList": serviceList == null ? [] : List<dynamic>.from(serviceList!.map((x) => x.toJson())),
  };
}

class ServiceList {
  int? id;
  String? name;
  String? description;
  int? serviceCategoryId;
  String? serviceCategoryName;
  double? commision;
  String? image;
  String? fileName;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  ServiceList({
    this.id,
    this.name,
    this.description,
    this.serviceCategoryId,
    this.serviceCategoryName,
    this.commision,
    this.image,
    this.fileName,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    serviceCategoryId: json["serviceCategoryId"],
    serviceCategoryName: json["serviceCategoryName"],
    commision: json["commision"]?.toDouble(),
    image: json["Image"],
    fileName: json["fileName"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "serviceCategoryId": serviceCategoryId,
    "serviceCategoryName": serviceCategoryName,
    "commision": commision,
    "Image": image,
    "fileName": fileName,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}
