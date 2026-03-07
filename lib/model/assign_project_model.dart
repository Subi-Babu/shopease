// To parse this JSON data, do
//
//     final assignProjectModel = assignProjectModelFromJson(jsonString);

import 'dart:convert';

AssignProjectModel assignProjectModelFromJson(String str) => AssignProjectModel.fromJson(json.decode(str));

String assignProjectModelToJson(AssignProjectModel data) => json.encode(data.toJson());

class AssignProjectModel {
  bool? status;
  String? message;
  List<ProjectDropDown>? projectDropDown;

  AssignProjectModel({
    this.status,
    this.message,
    this.projectDropDown,
  });

  factory AssignProjectModel.fromJson(Map<String, dynamic> json) => AssignProjectModel(
    status: json["status"],
    message: json["message"],
    projectDropDown: json["ProjectDropDown"] == null ? [] : List<ProjectDropDown>.from(json["ProjectDropDown"]!.map((x) => ProjectDropDown.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "ProjectDropDown": projectDropDown == null ? [] : List<dynamic>.from(projectDropDown!.map((x) => x.toJson())),
  };
}

class ProjectDropDown {
  int? value;
  String? label;
  int? walletBalance;

  ProjectDropDown({
    this.value,
    this.label,
    this.walletBalance,
  });

  factory ProjectDropDown.fromJson(Map<String, dynamic> json) => ProjectDropDown(
    value: json["value"],
    label: json["label"],
    walletBalance: json["walletBalance"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "walletBalance": walletBalance,
  };
}
