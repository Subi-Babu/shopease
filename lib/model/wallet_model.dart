// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  bool? status;
  String? message;
  int? budget;
  int? walletBalance;
  int? expenses;
  int? ybCash;
  int? page;
  int? limit;
  int? totalPages;
  int? totalRecords;
  List<Datum>? data;

  WalletModel({
    this.status,
    this.message,
    this.budget,
    this.walletBalance,
    this.expenses,
    this.ybCash,
    this.page,
    this.limit,
    this.totalPages,
    this.totalRecords,
    this.data,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    status: json["status"],
    message: json["message"],
    budget: json["budget"],
    walletBalance: json["walletBalance"],
    expenses: json["expenses"],
    ybCash: json["YBCash"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "budget": budget,
    "walletBalance": walletBalance,
    "expenses": expenses,
    "YBCash": ybCash,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? details;
  int? amount;
  DateTime? createdAt;
  dynamic projectId;
  String? projectName;
  String? type;
  int? expenseCategoryId;
  String? expenseCategoryName;

  Datum({
    this.id,
    this.details,
    this.amount,
    this.createdAt,
    this.projectId,
    this.projectName,
    this.type,
    this.expenseCategoryId,
    this.expenseCategoryName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    details: json["details"],
    amount: json["amount"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    projectId: json["projectId"],
    projectName: json["projectName"],
    type: json["type"],
    expenseCategoryId: json["expenseCategoryId"],
    expenseCategoryName: json["expenseCategoryName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "details": details,
    "amount": amount,
    "createdAt": createdAt?.toIso8601String(),
    "projectId": projectId,
    "projectName": projectName,
    "type": type,
    "expenseCategoryId": expenseCategoryId,
    "expenseCategoryName": expenseCategoryName,
  };
}
