// To parse this JSON data, do
//
//     final projectWithIdModel = projectWithIdModelFromJson(jsonString);

import 'dart:convert';

ProjectWithIdModel projectWithIdModelFromJson(String str) =>
    ProjectWithIdModel.fromJson(json.decode(str));

String projectWithIdModelToJson(ProjectWithIdModel data) =>
    json.encode(data.toJson());

class ProjectWithIdModel {
  bool? status;
  String? message;
  Data? data;

  ProjectWithIdModel({this.status, this.message, this.data});

  factory ProjectWithIdModel.fromJson(Map<String, dynamic> json) =>
      ProjectWithIdModel(
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
  String? description;
  String? projectId;
  DateTime? dueDate;
  dynamic startDate;
  String? workStatus;
  dynamic categoryId;
  dynamic category;
  int? budget;
  Users? users;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  Data({
    this.id,
    this.name,
    this.description,
    this.projectId,
    this.dueDate,
    this.startDate,
    this.workStatus,
    this.categoryId,
    this.category,
    this.budget,
    this.users,
    this.isActive,
    this.isDelete,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    projectId: json["projectId"],
    dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
    startDate: json["startDate"],
    workStatus: json["workStatus"],
    categoryId: json["categoryId"],
    category: json["category"],
    budget: json["budget"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "projectId": projectId,
    "dueDate": dueDate?.toIso8601String(),
    "startDate": startDate,
    "workStatus": workStatus,
    "categoryId": categoryId,
    "category": category,
    "budget": budget,
    "users": users?.toJson(),
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
  };
}

class Users {
  int? id;
  String? name;

  Users({this.id, this.name});

  factory Users.fromJson(Map<String, dynamic> json) =>
      Users(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
