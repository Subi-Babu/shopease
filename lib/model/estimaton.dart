// To parse this JSON data, do
//
//     final estimationModel = estimationModelFromJson(jsonString);

import 'dart:convert';

EstimationModel estimationModelFromJson(String str) => EstimationModel.fromJson(json.decode(str));

String estimationModelToJson(EstimationModel data) => json.encode(data.toJson());

class EstimationModel {
  bool? status;
  String? message;
  List<Datum>? data;

  EstimationModel({
    this.status,
    this.message,
    this.data,
  });

  factory EstimationModel.fromJson(Map<String, dynamic> json) => EstimationModel(
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
  String? email;
  String? code;
  String? phoneNumber;
  String? projectType;
  int? builtUpArea;
  int? budget;
  DateTime? date;
  dynamic document;
  dynamic fileName;
  dynamic size;
  String? message;
  dynamic location;
  int? pinCode;
  int? userId;
  DateTime? createdAt;
  bool? isActive;
  bool? isDelete;
  Users? users;

  Datum({
    this.id,
    this.name,
    this.email,
    this.code,
    this.phoneNumber,
    this.projectType,
    this.builtUpArea,
    this.budget,
    this.date,
    this.document,
    this.fileName,
    this.size,
    this.message,
    this.location,
    this.pinCode,
    this.userId,
    this.createdAt,
    this.isActive,
    this.isDelete,
    this.users,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    projectType: json["projectType"],
    builtUpArea: json["builtUpArea"],
    budget: json["budget"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    document: json["document"],
    fileName: json["fileName"],
    size: json["size"],
    message: json["message"],
    location: json["location"],
    pinCode: json["pinCode"],
    userId: json["userId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "code": code,
    "phoneNumber": phoneNumber,
    "projectType": projectType,
    "builtUpArea": builtUpArea,
    "budget": budget,
    "date": date?.toIso8601String(),
    "document": document,
    "fileName": fileName,
    "size": size,
    "message": message,
    "location": location,
    "pinCode": pinCode,
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "isActive": isActive,
    "isDelete": isDelete,
    "users": users?.toJson(),
  };
}

class Users {
  int? id;
  String? name;

  Users({
    this.id,
    this.name,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
