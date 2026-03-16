// To parse this JSON data, do
//
//     final categroyListModel = categroyListModelFromJson(jsonString);

import 'dart:convert';

CategroyListModel categroyListModelFromJson(String str) => CategroyListModel.fromJson(json.decode(str));

String categroyListModelToJson(CategroyListModel data) => json.encode(data.toJson());

class CategroyListModel {
  bool? status;
  String? message;
  List<CategoryList>? categoryList;

  CategroyListModel({
    this.status,
    this.message,
    this.categoryList,
  });

  factory CategroyListModel.fromJson(Map<String, dynamic> json) => CategroyListModel(
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
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  CategoryList({
    this.id,
    this.name,
    this.image,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "Image": image,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}
