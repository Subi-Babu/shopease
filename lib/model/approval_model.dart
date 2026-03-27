// To parse this JSON data, do
//
//     final approvalOederModel = approvalOederModelFromJson(jsonString);

import 'dart:convert';

ApprovalOederModel approvalOederModelFromJson(String str) =>
    ApprovalOederModel.fromJson(json.decode(str));

String approvalOederModelToJson(ApprovalOederModel data) =>
    json.encode(data.toJson());

class ApprovalOederModel {
  bool? status;
  String? message;
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  String? userType;
  List<Datum>? data;

  ApprovalOederModel({
    this.status,
    this.message,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.userType,
    this.data,
  });

  factory ApprovalOederModel.fromJson(Map<String, dynamic> json) =>
      ApprovalOederModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        userType: json["userType"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "userType": userType,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? orderId;
  int? userId;
  int? userAddressId;
  dynamic totalPrice;
  DateTime? createdAt;
  dynamic totalcalculatorPrice;
  dynamic grandTotal;
  dynamic discount;
  int? projectId;
  dynamic paidAmount;
  dynamic pendingAmount;
  String? orderStatus;
  String? deliveryStatus;
  String? paymentStatus;
  Users? users;
  Count? count;

  Datum({
    this.id,
    this.orderId,
    this.userId,
    this.userAddressId,
    this.totalPrice,
    this.createdAt,
    this.totalcalculatorPrice,
    this.grandTotal,
    this.discount,
    this.projectId,
    this.paidAmount,
    this.pendingAmount,
    this.orderStatus,
    this.deliveryStatus,
    this.paymentStatus,
    this.users,
    this.count,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    orderId: json["orderId"],
    userId: json["userId"],
    userAddressId: json["userAddressId"],
    totalPrice: json["totalPrice"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    totalcalculatorPrice: json["totalcalculatorPrice"],
    grandTotal: json["grandTotal"],
    discount: json["discount"],
    projectId: json["projectId"],
    paidAmount: json["paidAmount"],
    pendingAmount: json["pendingAmount"],
    orderStatus: json["orderStatus"],
    deliveryStatus: json["deliveryStatus"],
    paymentStatus: json["paymentStatus"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "userId": userId,
    "userAddressId": userAddressId,
    "totalPrice": totalPrice,
    "createdAt": createdAt?.toIso8601String(),
    "totalcalculatorPrice": totalcalculatorPrice,
    "grandTotal": grandTotal,
    "discount": discount,
    "projectId": projectId,
    "paidAmount": paidAmount,
    "pendingAmount": pendingAmount,
    "orderStatus": orderStatus,
    "deliveryStatus": deliveryStatus,
    "paymentStatus": paymentStatus,
    "users": users?.toJson(),
    "_count": count?.toJson(),
  };
}

class Count {
  int? orderItems;

  Count({this.orderItems});

  factory Count.fromJson(Map<String, dynamic> json) =>
      Count(orderItems: json["orderItems"]);

  Map<String, dynamic> toJson() => {"orderItems": orderItems};
}

class Users {
  int? id;
  String? name;

  Users({this.id, this.name});

  factory Users.fromJson(Map<String, dynamic> json) =>
      Users(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
