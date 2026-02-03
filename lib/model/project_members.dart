// To parse this JSON data, do
//
//     final projectMembersModel = projectMembersModelFromJson(jsonString);

import 'dart:convert';

ProjectMembersModel projectMembersModelFromJson(String str) => ProjectMembersModel.fromJson(json.decode(str));

String projectMembersModelToJson(ProjectMembersModel data) => json.encode(data.toJson());

class ProjectMembersModel {
  bool? status;
  String? message;
  Data? data;

  ProjectMembersModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProjectMembersModel.fromJson(Map<String, dynamic> json) => ProjectMembersModel(
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
  String? projectName;
  List<Member>? members;

  Data({
    this.projectName,
    this.members,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    projectName: json["projectName"],
    members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "projectName": projectName,
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
  };
}

class Member {
  int? projectId;
  String? projectName;
  int? userId;
  String? userName;
  dynamic profileImage;
  String? accessType;
  String? code;
  String? phoneNumber;
  dynamic createdAt;

  Member({
    this.projectId,
    this.projectName,
    this.userId,
    this.userName,
    this.profileImage,
    this.accessType,
    this.code,
    this.phoneNumber,
    this.createdAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    projectId: json["projectId"],
    projectName: json["projectName"],
    userId: json["userId"],
    userName: json["userName"],
    profileImage: json["profileImage"],
    accessType: json["accessType"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "projectId": projectId,
    "projectName": projectName,
    "userId": userId,
    "userName": userName,
    "profileImage": profileImage,
    "accessType": accessType,
    "code": code,
    "phoneNumber": phoneNumber,
    "createdAt": createdAt,
  };
}
