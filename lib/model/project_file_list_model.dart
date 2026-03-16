// To parse this JSON data, do
//
//     final projectFileListModel = projectFileListModelFromJson(jsonString);

import 'dart:convert';

ProjectFileListModel projectFileListModelFromJson(String str) => ProjectFileListModel.fromJson(json.decode(str));

String projectFileListModelToJson(ProjectFileListModel data) => json.encode(data.toJson());

class ProjectFileListModel {
  bool? status;
  String? message;
  String? totalSize;
  int? page;
  int? totalPages;
  int? totalFile;
  List<ProjectFileList>? projectFileList;

  ProjectFileListModel({
    this.status,
    this.message,
    this.totalSize,
    this.page,
    this.totalPages,
    this.totalFile,
    this.projectFileList,
  });

  factory ProjectFileListModel.fromJson(Map<String, dynamic> json) => ProjectFileListModel(
    status: json["status"],
    message: json["message"],
    totalSize: json["totalSize"],
    page: json["page"],
    totalPages: json["totalPages"],
    totalFile: json["totalFile"],
    projectFileList: json["ProjectFileList"] == null ? [] : List<ProjectFileList>.from(json["ProjectFileList"]!.map((x) => ProjectFileList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalSize": totalSize,
    "page": page,
    "totalPages": totalPages,
    "totalFile": totalFile,
    "ProjectFileList": projectFileList == null ? [] : List<dynamic>.from(projectFileList!.map((x) => x.toJson())),
  };
}

class ProjectFileList {
  int? id;
  String? location;
  String? fileName;
  int? size;
  String? type;
  int? projectId;
  String? projectName;
  String? userName;
  DateTime? createdAt;

  ProjectFileList({
    this.id,
    this.location,
    this.fileName,
    this.size,
    this.type,
    this.projectId,
    this.projectName,
    this.userName,
    this.createdAt,
  });

  factory ProjectFileList.fromJson(Map<String, dynamic> json) => ProjectFileList(
    id: json["id"],
    location: json["location"],
    fileName: json["fileName"],
    size: json["size"],
    type: json["type"],
    projectId: json["projectId"],
    projectName: json["projectName"],
    userName: json["userName"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "fileName": fileName,
    "size": size,
    "type": type,
    "projectId": projectId,
    "projectName": projectName,
    "userName": userName,
    "createdAt": createdAt?.toIso8601String(),
  };
}
