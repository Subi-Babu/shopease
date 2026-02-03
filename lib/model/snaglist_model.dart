// To parse this JSON data, do
//
//     final snagListModel = snagListModelFromJson(jsonString);

import 'dart:convert';

SnagListModel snagListModelFromJson(String str) =>
    SnagListModel.fromJson(json.decode(str));

String snagListModelToJson(SnagListModel data) => json.encode(data.toJson());

class SnagListModel {
  List<String>? status;
  String? message;
  int? page;
  int? totalPages;
  int? totalSnags;
  int? completedSnags;
  int? pendingSnags;
  List<String>? percentage;
  List<ProjectSnagList>? projectSnagList;

  SnagListModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.totalSnags,
    this.completedSnags,
    this.pendingSnags,
    this.percentage,
    this.projectSnagList,
  });

  factory SnagListModel.fromJson(Map<String, dynamic> json) => SnagListModel(
    status: json["status"] == null
        ? []
        : List<String>.from(json["status"]!.map((x) => x)),
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    totalSnags: json["TotalSnags"],
    completedSnags: json["CompletedSnags"],
    pendingSnags: json["PendingSnags"],
    percentage: json["percentage"] == null
        ? []
        : List<String>.from(json["percentage"]!.map((x) => x)),
    projectSnagList: json["ProjectSnagList"] == null
        ? []
        : List<ProjectSnagList>.from(
            json["ProjectSnagList"]!.map((x) => ProjectSnagList.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "TotalSnags": totalSnags,
    "CompletedSnags": completedSnags,
    "PendingSnags": pendingSnags,
    "percentage": percentage == null
        ? []
        : List<dynamic>.from(percentage!.map((x) => x)),
    "ProjectSnagList": projectSnagList == null
        ? []
        : List<dynamic>.from(projectSnagList!.map((x) => x.toJson())),
  };
}

class ProjectSnagList {
  int? id;
  String? details;
  double? percentage;
  num? completePercentage;
  int? snagStatusId;
  int? projectId;
  bool? isComplete;
  int? userId;
  Projects? projects;
  SnagStatus? snagStatus;

  ProjectSnagList({
    this.id,
    this.details,
    this.percentage,
    this.completePercentage,
    this.snagStatusId,
    this.projectId,
    this.isComplete,
    this.userId,
    this.projects,
    this.snagStatus,
  });

  factory ProjectSnagList.fromJson(Map<String, dynamic> json) =>
      ProjectSnagList(
        id: json["id"],
        details: json["details"],

        percentage: json['percentage']?.toDouble(),
        completePercentage: json['completePercentage'],
        snagStatusId: json["snagStatusId"],
        projectId: json["projectId"],
        isComplete: json["isComplete"],
        userId: json["userId"],
        projects: json["projects"] == null
            ? null
            : Projects.fromJson(json["projects"]),
        snagStatus: json["snagStatus"] == null
            ? null
            : SnagStatus.fromJson(json["snagStatus"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "details": details,
    "percentage": percentage,
    "completePercentage": completePercentage,
    "snagStatusId": snagStatusId,
    "projectId": projectId,
    "isComplete": isComplete,
    "userId": userId,
    "projects": projects?.toJson(),
    "snagStatus": snagStatus?.toJson(),
  };
}

class Projects {
  int? id;
  String? name;

  Projects({this.id, this.name});

  factory Projects.fromJson(Map<String, dynamic> json) =>
      Projects(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class SnagStatus {
  int? id;
  String? name;
  int? points;

  SnagStatus({this.id, this.name, this.points});

  factory SnagStatus.fromJson(Map<String, dynamic> json) =>
      SnagStatus(id: json["id"], name: json["name"], points: json["points"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "points": points};
}
