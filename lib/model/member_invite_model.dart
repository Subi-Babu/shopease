// To parse this JSON data, do
//
//     final memberInviteModelModel = memberInviteModelModelFromJson(jsonString);

import 'dart:convert';

MemberInviteModelModel memberInviteModelModelFromJson(String str) => MemberInviteModelModel.fromJson(json.decode(str));

String memberInviteModelModelToJson(MemberInviteModelModel data) => json.encode(data.toJson());

class MemberInviteModelModel {
  bool? status;
  String? message;
  List<ProjectMember>? projectMembers;

  MemberInviteModelModel({
    this.status,
    this.message,
    this.projectMembers,
  });

  factory MemberInviteModelModel.fromJson(Map<String, dynamic> json) => MemberInviteModelModel(
    status: json["status"],
    message: json["message"],
    projectMembers: json["projectMembers"] == null ? [] : List<ProjectMember>.from(json["projectMembers"]!.map((x) => ProjectMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "projectMembers": projectMembers == null ? [] : List<dynamic>.from(projectMembers!.map((x) => x.toJson())),
  };
}

class ProjectMember {
  int? id;
  int? projectId;
  int? userId;
  String? accessType;
  DateTime? createdAt;
  Projects? projects;
  int? projectMembers;

  ProjectMember({
    this.id,
    this.projectId,
    this.userId,
    this.accessType,
    this.createdAt,
    this.projects,
    this.projectMembers,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) => ProjectMember(
    id: json["id"],
    projectId: json["projectId"],
    userId: json["userId"],
    accessType: json["accessType"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    projects: json["projects"] == null ? null : Projects.fromJson(json["projects"]),
    projectMembers: json["projectMembers"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "projectId": projectId,
    "userId": userId,
    "accessType": accessType,
    "createdAt": createdAt?.toIso8601String(),
    "projects": projects?.toJson(),
    "projectMembers": projectMembers,
  };
}

class Projects {
  int? id;
  String? name;
  int? userId;
  Users? users;

  Projects({
    this.id,
    this.name,
    this.userId,
    this.users,
  });

  factory Projects.fromJson(Map<String, dynamic> json) => Projects(
    id: json["id"],
    name: json["name"],
    userId: json["userId"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "userId": userId,
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
