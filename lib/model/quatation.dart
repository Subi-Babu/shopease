// To parse this JSON data, do
//
//     final quatationModel = quatationModelFromJson(jsonString);

import 'dart:convert';

QuatationModel quatationModelFromJson(String str) => QuatationModel.fromJson(json.decode(str));

String quatationModelToJson(QuatationModel data) => json.encode(data.toJson());

class QuatationModel {
  bool? status;
  String? message;
  List<Datum>? data;

  QuatationModel({
    this.status,
    this.message,
    this.data,
  });

  factory QuatationModel.fromJson(Map<String, dynamic> json) => QuatationModel(
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
  int? plotArea;
  int? budget;
  DateTime? date;
  String? message;
  int? userId;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  dynamic location;
  int? pinCode;
  Users? users;

  Datum({
    this.id,
    this.name,
    this.email,
    this.code,
    this.phoneNumber,
    this.projectType,
    this.builtUpArea,
    this.plotArea,
    this.budget,
    this.date,
    this.message,
    this.userId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.location,
    this.pinCode,
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
    plotArea: json["plotArea"],
    budget: json["budget"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    message: json["message"],
    userId: json["userId"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    location: json["location"],
    pinCode: json["pinCode"],
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
    "plotArea": plotArea,
    "budget": budget,
    "date": date?.toIso8601String(),
    "message": message,
    "userId": userId,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "location": location,
    "pinCode": pinCode,
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
