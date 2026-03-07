// To parse this JSON data, do
//
//     final categoryQoutesListModel = categoryQoutesListModelFromJson(jsonString);

import 'dart:convert';

CategoryQoutesListModel categoryQoutesListModelFromJson(String str) => CategoryQoutesListModel.fromJson(json.decode(str));

String categoryQoutesListModelToJson(CategoryQoutesListModel data) => json.encode(data.toJson());

class CategoryQoutesListModel {
  bool? status;
  String? message;
  List<CategoryDropDown>? categoryDropDown;

  CategoryQoutesListModel({
    this.status,
    this.message,
    this.categoryDropDown,
  });

  factory CategoryQoutesListModel.fromJson(Map<String, dynamic> json) => CategoryQoutesListModel(
    status: json["status"],
    message: json["message"],
    categoryDropDown: json["CategoryDropDown"] == null ? [] : List<CategoryDropDown>.from(json["CategoryDropDown"]!.map((x) => CategoryDropDown.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "CategoryDropDown": categoryDropDown == null ? [] : List<dynamic>.from(categoryDropDown!.map((x) => x.toJson())),
  };
}

class CategoryDropDown {
  int? value;
  String? label;

  CategoryDropDown({
    this.value,
    this.label,
  });

  factory CategoryDropDown.fromJson(Map<String, dynamic> json) => CategoryDropDown(
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}
