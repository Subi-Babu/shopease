// To parse this JSON data, do
//
//     final serviceViewModel = serviceViewModelFromJson(jsonString);

import 'dart:convert';

ServiceViewModel serviceViewModelFromJson(String str) => ServiceViewModel.fromJson(json.decode(str));

String serviceViewModelToJson(ServiceViewModel data) => json.encode(data.toJson());

class ServiceViewModel {
  bool? status;
  String? message;
  Data? data;

  ServiceViewModel({
    this.status,
    this.message,
    this.data,
  });

  factory ServiceViewModel.fromJson(Map<String, dynamic> json) => ServiceViewModel(
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
  String? name;
  String? image;
  String? fileName;
  String? description;
  double? commision;
  int? serviceCategoryId;
  Category? serviceCategory;
  List<StageCategory>? stageCategory;
  bool? isFeatured;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  Data({
    this.id,
    this.name,
    this.image,
    this.fileName,
    this.description,
    this.commision,
    this.serviceCategoryId,
    this.serviceCategory,
    this.stageCategory,
    this.isFeatured,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
    fileName: json["fileName"],
    description: json["description"],
    commision: json["commision"]?.toDouble(),
    serviceCategoryId: json["serviceCategoryId"],
    serviceCategory: json["serviceCategory"] == null ? null : Category.fromJson(json["serviceCategory"]),
    stageCategory: json["stageCategory"] == null ? [] : List<StageCategory>.from(json["stageCategory"]!.map((x) => StageCategory.fromJson(x))),
    isFeatured: json["isFeatured"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "Image": image,
    "fileName": fileName,
    "description": description,
    "commision": commision,
    "serviceCategoryId": serviceCategoryId,
    "serviceCategory": serviceCategory?.toJson(),
    "stageCategory": stageCategory == null ? [] : List<dynamic>.from(stageCategory!.map((x) => x.toJson())),
    "isFeatured": isFeatured,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}

class Category {
  String? label;
  int? value;

  Category({
    this.label,
    this.value,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}

class StageCategory {
  Category? stageCategory;
  List<Category>? stageSubcategory;

  StageCategory({
    this.stageCategory,
    this.stageSubcategory,
  });

  factory StageCategory.fromJson(Map<String, dynamic> json) => StageCategory(
    stageCategory: json["stageCategory"] == null ? null : Category.fromJson(json["stageCategory"]),
    stageSubcategory: json["stageSubcategory"] == null ? [] : List<Category>.from(json["stageSubcategory"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "stageCategory": stageCategory?.toJson(),
    "stageSubcategory": stageSubcategory == null ? [] : List<dynamic>.from(stageSubcategory!.map((x) => x.toJson())),
  };
}
