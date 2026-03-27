// To parse this JSON data, do
//
//     final rentalModel = rentalModelFromJson(jsonString);

import 'dart:convert';

RentalModel rentalModelFromJson(String str) => RentalModel.fromJson(json.decode(str));

String rentalModelToJson(RentalModel data) => json.encode(data.toJson());

class RentalModel {
  bool? status;
  String? message;
  int? page;
  int? totalPages;
  List<Datum>? data;

  RentalModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.data,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) => RentalModel(
    status: json["status"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? description;
  int? rentalCategoryId;
  String? rentalCategoryName;
  String? image;
  String? fileName;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  Datum({
    this.id,
    this.name,
    this.description,
    this.rentalCategoryId,
    this.rentalCategoryName,
    this.image,
    this.fileName,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    rentalCategoryId: json["rentalCategoryId"],
    rentalCategoryName: json["rentalCategoryName"],
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
    "rentalCategoryId": rentalCategoryId,
    "rentalCategoryName": rentalCategoryName,
    "Image": image,
    "fileName": fileName,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}
