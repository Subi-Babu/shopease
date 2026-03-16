// To parse this JSON data, do
//
//     final stageCategoryModel = stageCategoryModelFromJson(jsonString);

import 'dart:convert';

StageCategoryModel stageCategoryModelFromJson(String str) => StageCategoryModel.fromJson(json.decode(str));

String stageCategoryModelToJson(StageCategoryModel data) => json.encode(data.toJson());

class StageCategoryModel {
  bool? status;
  String? message;
  List<Datum>? data;

  StageCategoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory StageCategoryModel.fromJson(Map<String, dynamic> json) => StageCategoryModel(
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
  DateTime? createdAt;
  String? image;
  String? fileName;
  bool? isCompleted;

  Datum({
    this.id,
    this.name,
    this.createdAt,
    this.image,
    this.fileName,
    this.isCompleted,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    image: json["Image"],
    fileName: json["fileName"],
    isCompleted: json["isCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "createdAt": createdAt?.toIso8601String(),
    "Image": image,
    "fileName": fileName,
    "isCompleted": isCompleted,
  };
}
