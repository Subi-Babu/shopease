// To parse this JSON data, do
//
//     final snagDropdownModel = snagDropdownModelFromJson(jsonString);

import 'dart:convert';

SnagDropdownModel snagDropdownModelFromJson(String str) => SnagDropdownModel.fromJson(json.decode(str));

String snagDropdownModelToJson(SnagDropdownModel data) => json.encode(data.toJson());

class SnagDropdownModel {
  bool? status;
  String? message;
  List<SnagStatusDropDown>? snagStatusDropDown;

  SnagDropdownModel({
    this.status,
    this.message,
    this.snagStatusDropDown,
  });

  factory SnagDropdownModel.fromJson(Map<String, dynamic> json) => SnagDropdownModel(
    status: json["status"],
    message: json["message"],
    snagStatusDropDown: json["snagStatusDropDown"] == null ? [] : List<SnagStatusDropDown>.from(json["snagStatusDropDown"]!.map((x) => SnagStatusDropDown.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "snagStatusDropDown": snagStatusDropDown == null ? [] : List<dynamic>.from(snagStatusDropDown!.map((x) => x.toJson())),
  };
}

class SnagStatusDropDown {
  int? value;
  String? label;

  SnagStatusDropDown({
    this.value,
    this.label,
  });

  factory SnagStatusDropDown.fromJson(Map<String, dynamic> json) => SnagStatusDropDown(
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}
