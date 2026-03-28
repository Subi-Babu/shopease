// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'dart:convert';

InvoiceModel invoiceModelFromJson(String str) =>
    InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  bool? status;
  String? message;
  Data? data;

  InvoiceModel({this.status, this.message, this.data});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? name;
  String? email;
  String? estimationId;
  String? code;
  String? phoneNumber;
  String? projectType;
  int? builtUpArea;
  dynamic budget;
  DateTime? date;
  String? document;
  String? fileName;
  int? size;
  String? message;
  String? status;
  String? location;
  int? pinCode;
  int? userId;
  DateTime? createdAt;
  bool? isActive;
  bool? isDelete;
  List<AdminEstimation>? adminEstimations;
  Users? users;

  Data({
    this.id,
    this.name,
    this.email,
    this.estimationId,
    this.code,
    this.phoneNumber,
    this.projectType,
    this.builtUpArea,
    this.budget,
    this.date,
    this.document,
    this.fileName,
    this.size,
    this.message,
    this.status,
    this.location,
    this.pinCode,
    this.userId,
    this.createdAt,
    this.isActive,
    this.isDelete,
    this.adminEstimations,
    this.users,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    estimationId: json["estimationId"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    projectType: json["projectType"],
    builtUpArea: json["builtUpArea"],
    budget: json["budget"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    document: json["document"],
    fileName: json["fileName"],
    size: json["size"],
    message: json["message"],
    status: json["status"],
    location: json["location"],
    pinCode: json["pinCode"],
    userId: json["userId"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    adminEstimations: json["adminEstimations"] == null
        ? []
        : List<AdminEstimation>.from(
            json["adminEstimations"]!.map((x) => AdminEstimation.fromJson(x)),
          ),
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "estimationId": estimationId,
    "code": code,
    "phoneNumber": phoneNumber,
    "projectType": projectType,
    "builtUpArea": builtUpArea,
    "budget": budget,
    "date": date?.toIso8601String(),
    "document": document,
    "fileName": fileName,
    "size": size,
    "message": message,
    "status": status,
    "location": location,
    "pinCode": pinCode,
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "isActive": isActive,
    "isDelete": isDelete,
    "adminEstimations": adminEstimations == null
        ? []
        : List<dynamic>.from(adminEstimations!.map((x) => x.toJson())),
    "users": users?.toJson(),
  };
}

class AdminEstimation {
  int? id;
  int? estimationId;
  String? estimationStatus;
  DateTime? createdAt;
  String? terms;
  String? notes;
  dynamic subTotal;
  dynamic discount;
  dynamic grandTotal;
  DateTime? updatedAt;
  String? uploadBy;
  int? adminId;
  List<AdminEstimationItem>? adminEstimationItems;
  List<dynamic>? adminEstimationFiles;
  List<AdminEstimationNote>? adminEstimationNotes;

  AdminEstimation({
    this.id,
    this.estimationId,
    this.estimationStatus,
    this.createdAt,
    this.terms,
    this.notes,
    this.subTotal,
    this.discount,
    this.grandTotal,
    this.updatedAt,
    this.uploadBy,
    this.adminId,
    this.adminEstimationItems,
    this.adminEstimationFiles,
    this.adminEstimationNotes,
  });

  factory AdminEstimation.fromJson(Map<String, dynamic> json) =>
      AdminEstimation(
        id: json["id"],
        estimationId: json["estimationId"],
        estimationStatus: json["estimationStatus"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        terms: json["terms"],
        notes: json["notes"],
        subTotal: json["subTotal"],
        discount: json["discount"],
        grandTotal: json["grandTotal"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        uploadBy: json["uploadBy"],
        adminId: json["adminId"],
        adminEstimationItems: json["adminEstimationItems"] == null
            ? []
            : List<AdminEstimationItem>.from(
                json["adminEstimationItems"]!.map(
                  (x) => AdminEstimationItem.fromJson(x),
                ),
              ),
        adminEstimationFiles: json["adminEstimationFiles"] == null
            ? []
            : List<dynamic>.from(json["adminEstimationFiles"]!.map((x) => x)),
        adminEstimationNotes: json["adminEstimationNotes"] == null
            ? []
            : List<AdminEstimationNote>.from(
                json["adminEstimationNotes"]!.map(
                  (x) => AdminEstimationNote.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "estimationId": estimationId,
    "estimationStatus": estimationStatus,
    "createdAt": createdAt?.toIso8601String(),
    "terms": terms,
    "notes": notes,
    "subTotal": subTotal,
    "discount": discount,
    "grandTotal": grandTotal,
    "updatedAt": updatedAt?.toIso8601String(),
    "uploadBy": uploadBy,
    "adminId": adminId,
    "adminEstimationItems": adminEstimationItems == null
        ? []
        : List<dynamic>.from(adminEstimationItems!.map((x) => x.toJson())),
    "adminEstimationFiles": adminEstimationFiles == null
        ? []
        : List<dynamic>.from(adminEstimationFiles!.map((x) => x)),
    "adminEstimationNotes": adminEstimationNotes == null
        ? []
        : List<dynamic>.from(adminEstimationNotes!.map((x) => x.toJson())),
  };
}

class AdminEstimationItem {
  int? id;
  int? adminEstimationId;
  String? description;
  int? qty;
  String? units;
  dynamic cost;
  dynamic tax;
  dynamic totalCost;
  DateTime? createdAt;
  DateTime? updatedAt;

  AdminEstimationItem({
    this.id,
    this.adminEstimationId,
    this.description,
    this.qty,
    this.units,
    this.cost,
    this.tax,
    this.totalCost,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminEstimationItem.fromJson(Map<String, dynamic> json) =>
      AdminEstimationItem(
        id: json["id"],
        adminEstimationId: json["adminEstimationId"],
        description: json["description"],
        qty: json["qty"],
        units: json["units"],
        cost: json["cost"],
        tax: json["tax"],
        totalCost: json["totalCost"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "adminEstimationId": adminEstimationId,
    "description": description,
    "qty": qty,
    "units": units,
    "cost": cost,
    "tax": tax,
    "totalCost": totalCost,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class AdminEstimationNote {
  int? id;
  int? adminEstimationId;
  String? name;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  AdminEstimationNote({
    this.id,
    this.adminEstimationId,
    this.name,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminEstimationNote.fromJson(Map<String, dynamic> json) =>
      AdminEstimationNote(
        id: json["id"],
        adminEstimationId: json["adminEstimationId"],
        name: json["name"],
        notes: json["notes"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "adminEstimationId": adminEstimationId,
    "name": name,
    "notes": notes,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Users {
  int? id;
  String? name;

  Users({this.id, this.name});

  factory Users.fromJson(Map<String, dynamic> json) =>
      Users(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
