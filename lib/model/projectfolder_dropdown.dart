// To parse this JSON data, do
//
//     final projectFolderDropModel = projectFolderDropModelFromJson(jsonString);

import 'dart:convert';

ProjectFolderDropModel projectFolderDropModelFromJson(String str) =>
    ProjectFolderDropModel.fromJson(json.decode(str));

String projectFolderDropModelToJson(ProjectFolderDropModel data) =>
    json.encode(data.toJson());

class ProjectFolderDropModel {
  bool? status;
  String? message;
  List<ProjectFolder>? projectFolders;

  ProjectFolderDropModel({this.status, this.message, this.projectFolders});

  factory ProjectFolderDropModel.fromJson(Map<String, dynamic> json) =>
      ProjectFolderDropModel(
        status: json["status"],
        message: json["message"],
        projectFolders: json["ProjectFolders"] == null
            ? []
            : List<ProjectFolder>.from(
                json["ProjectFolders"]!.map((x) => ProjectFolder.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "ProjectFolders": projectFolders == null
        ? []
        : List<dynamic>.from(projectFolders!.map((x) => x.toJson())),
  };
}

class ProjectFolder {
  int? value;
  String? label;

  ProjectFolder({this.value, this.label});

  factory ProjectFolder.fromJson(Map<String, dynamic> json) =>
      ProjectFolder(value: json["value"], label: json["label"]);

  Map<String, dynamic> toJson() => {"value": value, "label": label};
}
