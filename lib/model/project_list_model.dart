// To parse this JSON data, do
//
//     final projectListModel = projectListModelFromJson(jsonString);

import 'dart:convert';

ProjectListModel projectListModelFromJson(String str) => ProjectListModel.fromJson(json.decode(str));

String projectListModelToJson(ProjectListModel data) => json.encode(data.toJson());

class ProjectListModel {
  bool? status;
  String? message;
  int? page;
  int? totalPages;
  int? totalproject;
  StatusCount? statusCount;
  List<ProjectList>? projectList;

  ProjectListModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.totalproject,
    this.statusCount,
    this.projectList,
  });

  factory ProjectListModel.fromJson(Map<String, dynamic> json) => ProjectListModel(
    status: json["status"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    totalproject: json["totalproject"],
    statusCount: json["statusCount"] == null ? null : StatusCount.fromJson(json["statusCount"]),
    projectList: json["ProjectList"] == null ? [] : List<ProjectList>.from(json["ProjectList"]!.map((x) => ProjectList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "totalproject": totalproject,
    "statusCount": statusCount?.toJson(),
    "ProjectList": projectList == null ? [] : List<dynamic>.from(projectList!.map((x) => x.toJson())),
  };
}

class ProjectList {
  int? id;
  String? name;
  String? description;
  DateTime? dueDate;
  int? budget;
  String? workStatus;
  String? userName;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  List<ProjectMember>? projectMembers;

  ProjectList({
    this.id,
    this.name,
    this.description,
    this.dueDate,
    this.budget,
    this.workStatus,
    this.userName,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.projectMembers,
  });

  factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
    budget: json["budget"],
    workStatus: json["workStatus"],
    userName: json["userName"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    projectMembers: json["projectMembers"] == null ? [] : List<ProjectMember>.from(json["projectMembers"]!.map((x) => ProjectMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "dueDate": dueDate?.toIso8601String(),
    "budget": budget,
    "workStatus": workStatus,
    "userName": userName,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "projectMembers": projectMembers == null ? [] : List<dynamic>.from(projectMembers!.map((x) => x.toJson())),
  };
}

class ProjectMember {
  int? userId;
  String? membersStatus;
  String? accessType;
  Users? users;

  ProjectMember({
    this.userId,
    this.membersStatus,
    this.accessType,
    this.users,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) => ProjectMember(
    userId: json["userId"],
    membersStatus: json["membersStatus"],
    accessType: json["accessType"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "membersStatus": membersStatus,
    "accessType": accessType,
    "users": users?.toJson(),
  };
}

class Users {
  int? id;
  String? name;
  dynamic profileImage;
  dynamic fileName;

  Users({
    this.id,
    this.name,
    this.profileImage,
    this.fileName,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    profileImage: json["profileImage"],
    fileName: json["fileName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profileImage": profileImage,
    "fileName": fileName,
  };
}

class StatusCount {
  int? completed;
  int? onHold;
  int? inProcess;
  int? ongoing;
  int? notStarted;

  StatusCount({
    this.completed,
    this.onHold,
    this.inProcess,
    this.ongoing,
    this.notStarted,
  });

  factory StatusCount.fromJson(Map<String, dynamic> json) => StatusCount(
    completed: json["completed"],
    onHold: json["onHold"],
    inProcess: json["inProcess"],
    ongoing: json["Ongoing"],
    notStarted: json["notStarted"],
  );

  Map<String, dynamic> toJson() => {
    "completed": completed,
    "onHold": onHold,
    "inProcess": inProcess,
    "Ongoing": ongoing,
    "notStarted": notStarted,
  };
}
