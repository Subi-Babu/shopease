// To parse this JSON data, do
//
//     final projectTypeModel = projectTypeModelFromJson(jsonString);

import 'dart:convert';

ProjectTypeModel projectTypeModelFromJson(String str) => ProjectTypeModel.fromJson(json.decode(str));

String projectTypeModelToJson(ProjectTypeModel data) => json.encode(data.toJson());

class ProjectTypeModel {
  bool? status;
  String? message;
  List<ProjectTypeDropDown>? projectTypeDropDown;

  ProjectTypeModel({
    this.status,
    this.message,
    this.projectTypeDropDown,
  });

  factory ProjectTypeModel.fromJson(Map<String, dynamic> json) => ProjectTypeModel(
    status: json["status"],
    message: json["message"],
    projectTypeDropDown: json["projectTypeDropDown"] == null ? [] : List<ProjectTypeDropDown>.from(json["projectTypeDropDown"]!.map((x) => ProjectTypeDropDown.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "projectTypeDropDown": projectTypeDropDown == null ? [] : List<dynamic>.from(projectTypeDropDown!.map((x) => x.toJson())),
  };
}

class ProjectTypeDropDown {
  int? value;
  String? label;

  ProjectTypeDropDown({
    this.value,
    this.label,
  });

  factory ProjectTypeDropDown.fromJson(Map<String, dynamic> json) => ProjectTypeDropDown(
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}
