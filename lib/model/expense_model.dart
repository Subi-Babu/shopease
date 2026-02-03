// To parse this JSON data, do
//
//     final expensesDropModel = expensesDropModelFromJson(jsonString);

import 'dart:convert';

ExpensesDropModel expensesDropModelFromJson(String str) => ExpensesDropModel.fromJson(json.decode(str));

String expensesDropModelToJson(ExpensesDropModel data) => json.encode(data.toJson());

class ExpensesDropModel {
  bool? status;
  String? message;
  List<ExpenseCategoryDropDown>? expenseCategoryDropDown;

  ExpensesDropModel({
    this.status,
    this.message,
    this.expenseCategoryDropDown,
  });

  factory ExpensesDropModel.fromJson(Map<String, dynamic> json) => ExpensesDropModel(
    status: json["status"],
    message: json["message"],
    expenseCategoryDropDown: json["ExpenseCategoryDropDown"] == null ? [] : List<ExpenseCategoryDropDown>.from(json["ExpenseCategoryDropDown"]!.map((x) => ExpenseCategoryDropDown.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "ExpenseCategoryDropDown": expenseCategoryDropDown == null ? [] : List<dynamic>.from(expenseCategoryDropDown!.map((x) => x.toJson())),
  };
}

class ExpenseCategoryDropDown {
  int? value;
  String? label;

  ExpenseCategoryDropDown({
    this.value,
    this.label,
  });

  factory ExpenseCategoryDropDown.fromJson(Map<String, dynamic> json) => ExpenseCategoryDropDown(
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}
