// To parse this JSON data, do
//
//     final rentalViewModel = rentalViewModelFromJson(jsonString);

import 'dart:convert';

RentalViewModel rentalViewModelFromJson(String str) => RentalViewModel.fromJson(json.decode(str));

String rentalViewModelToJson(RentalViewModel data) => json.encode(data.toJson());

class RentalViewModel {
  bool? status;
  String? message;
  Data? data;

  RentalViewModel({
    this.status,
    this.message,
    this.data,
  });

  factory RentalViewModel.fromJson(Map<String, dynamic> json) => RentalViewModel(
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
  int? rentalCategoryId;
  RentalCategory? rentalCategory;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  Data({
    this.id,
    this.name,
    this.image,
    this.fileName,
    this.description,
    this.rentalCategoryId,
    this.rentalCategory,
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
    rentalCategoryId: json["rentalCategoryId"],
    rentalCategory: json["rentalCategory"] == null ? null : RentalCategory.fromJson(json["rentalCategory"]),
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
    "rentalCategoryId": rentalCategoryId,
    "rentalCategory": rentalCategory?.toJson(),
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}

class RentalCategory {
  String? label;
  int? value;

  RentalCategory({
    this.label,
    this.value,
  });

  factory RentalCategory.fromJson(Map<String, dynamic> json) => RentalCategory(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}
