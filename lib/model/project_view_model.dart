// To parse this JSON data, do
//
//     final projectListViewModel = projectListViewModelFromJson(jsonString);

import 'dart:convert';

ProjectListViewModel projectListViewModelFromJson(String str) => ProjectListViewModel.fromJson(json.decode(str));

String projectListViewModelToJson(ProjectListViewModel data) => json.encode(data.toJson());

class ProjectListViewModel {
  bool? status;
  String? message;
  Data? data;

  ProjectListViewModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProjectListViewModel.fromJson(Map<String, dynamic> json) => ProjectListViewModel(
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
  DateTime? dueDate;
  dynamic startDate;
  String? workStatus;
  int? budget;
  Users? users;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;

  Data({
    this.id,
    this.name,
    this.description,
    this.dueDate,
    this.startDate,
    this.workStatus,
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
    dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
    startDate: json["startDate"],
    workStatus: json["workStatus"],
    budget: json["budget"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "dueDate": dueDate?.toIso8601String(),
    "startDate": startDate,
    "workStatus": workStatus,
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
