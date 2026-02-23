// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
  bool? status;
  String? message;
  List<CategoryList>? categoryList;

  SubCategoryModel({
    this.status,
    this.message,
    this.categoryList,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    status: json["status"],
    message: json["message"],
    categoryList: json["CategoryList"] == null ? [] : List<CategoryList>.from(json["CategoryList"]!.map((x) => CategoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "CategoryList": categoryList == null ? [] : List<dynamic>.from(categoryList!.map((x) => x.toJson())),
  };
}

class CategoryList {
  int? id;
  String? name;
  String? image;
  int? categoryId;
  String? categoryName;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  CategoryList({
    this.id,
    this.name,
    this.image,
    this.categoryId,
    this.categoryName,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "Image": image,
    "categoryId": categoryId,
    "categoryName": categoryName,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}
