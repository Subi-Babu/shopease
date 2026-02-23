// To parse this JSON data, do
//
//     final brandModel = brandModelFromJson(jsonString);

import 'dart:convert';

BrandModel brandModelFromJson(String str) => BrandModel.fromJson(json.decode(str));

String brandModelToJson(BrandModel data) => json.encode(data.toJson());

class BrandModel {
  bool? status;
  String? message;
  List<BrandsList>? brandsList;

  BrandModel({
    this.status,
    this.message,
    this.brandsList,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    status: json["status"],
    message: json["message"],
    brandsList: json["BrandsList"] == null ? [] : List<BrandsList>.from(json["BrandsList"]!.map((x) => BrandsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "BrandsList": brandsList == null ? [] : List<dynamic>.from(brandsList!.map((x) => x.toJson())),
  };
}

class BrandsList {
  int? id;
  String? name;
  String? image;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  BrandsList({
    this.id,
    this.name,
    this.image,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory BrandsList.fromJson(Map<String, dynamic> json) => BrandsList(
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
