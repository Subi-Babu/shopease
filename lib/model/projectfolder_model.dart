// To parse this JSON data, do
//
//     final projectFolderModel = projectFolderModelFromJson(jsonString);

import 'dart:convert';

ProjectFolderModel projectFolderModelFromJson(String str) =>
    ProjectFolderModel.fromJson(json.decode(str));

String projectFolderModelToJson(ProjectFolderModel data) =>
    json.encode(data.toJson());

class ProjectFolderModel {
  bool? status;
  String? message;
  List<ProjectFolder>? projectFolders;

  ProjectFolderModel({this.status, this.message, this.projectFolders});

  factory ProjectFolderModel.fromJson(Map<String, dynamic> json) =>
      ProjectFolderModel(
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
