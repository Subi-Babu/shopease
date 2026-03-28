// To parse this JSON data, do
//
//     final rentalCategoryModel = rentalCategoryModelFromJson(jsonString);

import 'dart:convert';

RentalCategoryModel rentalCategoryModelFromJson(String str) => RentalCategoryModel.fromJson(json.decode(str));

String rentalCategoryModelToJson(RentalCategoryModel data) => json.encode(data.toJson());

class RentalCategoryModel {
  bool? status;
  String? message;
  List<Datum>? data;

  RentalCategoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory RentalCategoryModel.fromJson(Map<String, dynamic> json) => RentalCategoryModel(
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
  String? name;
  String? image;
  String? fileName;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  Datum({
    this.id,
    this.name,
    this.image,
    this.fileName,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
