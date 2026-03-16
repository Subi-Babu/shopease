// To parse this JSON data, do
//
//     final serviceCategryListModel = serviceCategryListModelFromJson(jsonString);

import 'dart:convert';

ServiceCategryListModel serviceCategryListModelFromJson(String str) => ServiceCategryListModel.fromJson(json.decode(str));

String serviceCategryListModelToJson(ServiceCategryListModel data) => json.encode(data.toJson());

class ServiceCategryListModel {
  bool? status;
  String? message;
  int? page;
  int? totalPages;
  List<ServiceCategoryList>? serviceCategoryList;

  ServiceCategryListModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.serviceCategoryList,
  });

  factory ServiceCategryListModel.fromJson(Map<String, dynamic> json) => ServiceCategryListModel(
    status: json["status"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    serviceCategoryList: json["ServiceCategoryList"] == null ? [] : List<ServiceCategoryList>.from(json["ServiceCategoryList"]!.map((x) => ServiceCategoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "ServiceCategoryList": serviceCategoryList == null ? [] : List<dynamic>.from(serviceCategoryList!.map((x) => x.toJson())),
  };
}

class ServiceCategoryList {
  int? id;
  String? name;
  String? image;
  String? fileName;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  ServiceCategoryList({
    this.id,
    this.name,
    this.image,
    this.fileName,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory ServiceCategoryList.fromJson(Map<String, dynamic> json) => ServiceCategoryList(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
    fileName: json["fileName"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "Image": image,
    "fileName": fileName,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}
