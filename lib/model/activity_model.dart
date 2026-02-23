// To parse this JSON data, do
//
//     final activityModel = activityModelFromJson(jsonString);
import 'dart:convert';

ActivityModel activityModelFromJson(String str) =>
    ActivityModel.fromJson(json.decode(str));
String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  bool? status;
  String? message;
  List<ProjectActivity>? projectActivity;

  ActivityModel({this.status, this.message, this.projectActivity});

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    status: json["status"],
    message: json["message"],
    projectActivity: json["projectActivity"] == null
        ? []
        : List<ProjectActivity>.from(
            json["projectActivity"]!.map((x) => ProjectActivity.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "projectActivity": projectActivity == null
        ? []
        : List<dynamic>.from(projectActivity!.map((x) => x.toJson())),
  };
}

class ProjectActivity {
  int? id;
  String? type;
  String? description;
  int? userId;
  DateTime? createdAt;
  Users? users;

  ProjectActivity({
    this.id,
    this.type,
    this.description,
    this.userId,
    this.createdAt,
    this.users,
  });

  factory ProjectActivity.fromJson(Map<String, dynamic> json) =>
      ProjectActivity(
        id: json["id"],
        type: json["type"],
        description: json["description"],
        userId: json["userId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "description": description,
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "users": users?.toJson(),
  };
}

class Users {
  int? id;
  String? name;
  dynamic profileImage;

  Users({this.id, this.name, this.profileImage});

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profileImage": profileImage,
  };
}
