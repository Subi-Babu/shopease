// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  bool? status;
  Data? data;

  ProfileModel({
    this.status,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? name;
  String? phoneNumber;
  String? code;
  dynamic email;
  dynamic gender;
  dynamic profileImage;
  dynamic fileName;
  bool? isActive;
  bool? isDelete;
  DateTime? lastVisit;

  Data({
    this.id,
    this.name,
    this.phoneNumber,
    this.code,
    this.email,
    this.gender,
    this.profileImage,
    this.fileName,
    this.isActive,
    this.isDelete,
    this.lastVisit,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    code: json["code"],
    email: json["email"],
    gender: json["gender"],
    profileImage: json["profileImage"],
    fileName: json["fileName"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    lastVisit: json["lastVisit"] == null ? null : DateTime.parse(json["lastVisit"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phoneNumber": phoneNumber,
    "code": code,
    "email": email,
    "gender": gender,
    "profileImage": profileImage,
    "fileName": fileName,
    "isActive": isActive,
    "isDelete": isDelete,
    "lastVisit": lastVisit?.toIso8601String(),
  };
}
