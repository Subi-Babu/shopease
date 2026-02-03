// To parse this JSON data, do
//
//     final countryCodeModel = countryCodeModelFromJson(jsonString);

import 'dart:convert';

CountryCodeModel countryCodeModelFromJson(String str) => CountryCodeModel.fromJson(json.decode(str));

String countryCodeModelToJson(CountryCodeModel data) => json.encode(data.toJson());

class CountryCodeModel {
  bool? status;
  String? message;
  List<CountryCode>? countryCode;

  CountryCodeModel({
    this.status,
    this.message,
    this.countryCode,
  });

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) => CountryCodeModel(
    status: json["status"],
    message: json["message"],
    countryCode: json["CountryCode"] == null ? [] : List<CountryCode>.from(json["CountryCode"]!.map((x) => CountryCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "CountryCode": countryCode == null ? [] : List<dynamic>.from(countryCode!.map((x) => x.toJson())),
  };
}

class CountryCode {
  int? value;
  String? label;

  CountryCode({
    this.value,
    this.label,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}
