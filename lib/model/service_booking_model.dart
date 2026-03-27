// To parse this JSON data, do
//
//     final serviceBookingModel = serviceBookingModelFromJson(jsonString);

import 'dart:convert';

ServiceBookingModel serviceBookingModelFromJson(String str) => ServiceBookingModel.fromJson(json.decode(str));

String serviceBookingModelToJson(ServiceBookingModel data) => json.encode(data.toJson());

class ServiceBookingModel {
  bool? status;
  String? message;
  List<Datum>? data;

  ServiceBookingModel({
    this.status,
    this.message,
    this.data,
  });

  factory ServiceBookingModel.fromJson(Map<String, dynamic> json) => ServiceBookingModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? serviceBookingId;
  int? userId;
  int? serviceId;
  int? serviceHubId;
  int? serviceManId;
  int? userAddressId;
  String? name;
  String? code;
  String? phoneNumber;
  DateTime? date;
  String? message;
  dynamic fileName;
  dynamic file;
  dynamic size;
  int? grandTotal;
  dynamic invoiceAmount;
  dynamic discount;
  dynamic paidAmount;
  int? pendingAmount;
  dynamic gst;
  int? cgst;
  int? sgst;
  int? igst;
  int? commision;
  dynamic commisionTax;
  String? serviceManUrl;
  int? serviceHubDistance;
  int? serviceManDistance;
  String? paymentStatus;
  String? status;
  String? serviceManstatus;
  bool? isMaterialPurchase;
  dynamic orderId;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic projectId;
  dynamic projects;
  Service? service;
  ServiceHub? users;
  UserAddress? userAddress;
  ServiceHub? serviceHub;
  ServiceHub? serviceMan;
  dynamic order;
  List<dynamic>? serviceBookingTransactions;
  List<ServiceCart>? serviceCarts;
  List<ServiceInspectionReport>? serviceInspectionReports;

  Datum({
    this.id,
    this.serviceBookingId,
    this.userId,
    this.serviceId,
    this.serviceHubId,
    this.serviceManId,
    this.userAddressId,
    this.name,
    this.code,
    this.phoneNumber,
    this.date,
    this.message,
    this.fileName,
    this.file,
    this.size,
    this.grandTotal,
    this.invoiceAmount,
    this.discount,
    this.paidAmount,
    this.pendingAmount,
    this.gst,
    this.cgst,
    this.sgst,
    this.igst,
    this.commision,
    this.commisionTax,
    this.serviceManUrl,
    this.serviceHubDistance,
    this.serviceManDistance,
    this.paymentStatus,
    this.status,
    this.serviceManstatus,
    this.isMaterialPurchase,
    this.orderId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.projectId,
    this.projects,
    this.service,
    this.users,
    this.userAddress,
    this.serviceHub,
    this.serviceMan,
    this.order,
    this.serviceBookingTransactions,
    this.serviceCarts,
    this.serviceInspectionReports,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    serviceBookingId: json["serviceBookingId"],
    userId: json["userId"],
    serviceId: json["serviceId"],
    serviceHubId: json["serviceHubId"],
    serviceManId: json["serviceManId"],
    userAddressId: json["userAddressId"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    message: json["message"],
    fileName: json["fileName"],
    file: json["file"],
    size: json["size"],
    grandTotal: json["grandTotal"],
    invoiceAmount: json["invoiceAmount"],
    discount: json["discount"],
    paidAmount: json["paidAmount"],
    pendingAmount: json["pendingAmount"],
    gst: json["gst"],
    cgst: json["CGST"],
    sgst: json["SGST"],
    igst: json["IGST"],
    commision: json["commision"],
    commisionTax: json["commisionTax"],
    serviceManUrl: json["serviceManURL"],
    serviceHubDistance: json["serviceHubDistance"],
    serviceManDistance: json["serviceManDistance"],
    paymentStatus: json["paymentStatus"],
    status: json["status"],
    serviceManstatus: json["serviceManstatus"],
    isMaterialPurchase: json["isMaterialPurchase"],
    orderId: json["orderId"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    projectId: json["projectId"],
    projects: json["projects"],
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    users: json["users"] == null ? null : ServiceHub.fromJson(json["users"]),
    userAddress: json["userAddress"] == null ? null : UserAddress.fromJson(json["userAddress"]),
    serviceHub: json["serviceHub"] == null ? null : ServiceHub.fromJson(json["serviceHub"]),
    serviceMan: json["serviceMan"] == null ? null : ServiceHub.fromJson(json["serviceMan"]),
    order: json["order"],
    serviceBookingTransactions: json["serviceBookingTransactions"] == null ? [] : List<dynamic>.from(json["serviceBookingTransactions"]!.map((x) => x)),
    serviceCarts: json["serviceCarts"] == null ? [] : List<ServiceCart>.from(json["serviceCarts"]!.map((x) => ServiceCart.fromJson(x))),
    serviceInspectionReports: json["serviceInspectionReports"] == null ? [] : List<ServiceInspectionReport>.from(json["serviceInspectionReports"]!.map((x) => ServiceInspectionReport.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceBookingId": serviceBookingId,
    "userId": userId,
    "serviceId": serviceId,
    "serviceHubId": serviceHubId,
    "serviceManId": serviceManId,
    "userAddressId": userAddressId,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
    "date": date?.toIso8601String(),
    "message": message,
    "fileName": fileName,
    "file": file,
    "size": size,
    "grandTotal": grandTotal,
    "invoiceAmount": invoiceAmount,
    "discount": discount,
    "paidAmount": paidAmount,
    "pendingAmount": pendingAmount,
    "gst": gst,
    "CGST": cgst,
    "SGST": sgst,
    "IGST": igst,
    "commision": commision,
    "commisionTax": commisionTax,
    "serviceManURL": serviceManUrl,
    "serviceHubDistance": serviceHubDistance,
    "serviceManDistance": serviceManDistance,
    "paymentStatus": paymentStatus,
    "status": status,
    "serviceManstatus": serviceManstatus,
    "isMaterialPurchase": isMaterialPurchase,
    "orderId": orderId,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "projectId": projectId,
    "projects": projects,
    "service": service?.toJson(),
    "users": users?.toJson(),
    "userAddress": userAddress?.toJson(),
    "serviceHub": serviceHub?.toJson(),
    "serviceMan": serviceMan?.toJson(),
    "order": order,
    "serviceBookingTransactions": serviceBookingTransactions == null ? [] : List<dynamic>.from(serviceBookingTransactions!.map((x) => x)),
    "serviceCarts": serviceCarts == null ? [] : List<dynamic>.from(serviceCarts!.map((x) => x.toJson())),
    "serviceInspectionReports": serviceInspectionReports == null ? [] : List<dynamic>.from(serviceInspectionReports!.map((x) => x.toJson())),
  };
}

class Service {
  int? id;
  String? name;
  String? image;

  Service({
    this.id,
    this.name,
    this.image,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "Image": image,
  };
}

class ServiceCart {
  int? id;
  int? serviceHubId;
  int? serviceBookingId;
  int? storeId;
  int? itemId;
  int? userId;
  int? mrp;
  int? calculatorPrice;
  int? qty;
  int? cgst;
  int? sgst;
  double? igst;
  double? commision;
  dynamic categoryId;
  dynamic projectId;
  List<Attributecategory>? attributecategory;
  AttributeName? attributeName;
  dynamic orderId;
  bool? isOrder;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  ServiceCart({
    this.id,
    this.serviceHubId,
    this.serviceBookingId,
    this.storeId,
    this.itemId,
    this.userId,
    this.mrp,
    this.calculatorPrice,
    this.qty,
    this.cgst,
    this.sgst,
    this.igst,
    this.commision,
    this.categoryId,
    this.projectId,
    this.attributecategory,
    this.attributeName,
    this.orderId,
    this.isOrder,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceCart.fromJson(Map<String, dynamic> json) => ServiceCart(
    id: json["id"],
    serviceHubId: json["serviceHubId"],
    serviceBookingId: json["serviceBookingId"],
    storeId: json["storeId"],
    itemId: json["itemId"],
    userId: json["userId"],
    mrp: json["mrp"],
    calculatorPrice: json["calculatorPrice"],
    qty: json["qty"],
    cgst: json["CGST"],
    sgst: json["SGST"],
    igst: json["IGST"]?.toDouble(),
    commision: json["commision"]?.toDouble(),
    categoryId: json["categoryId"],
    projectId: json["projectId"],
    attributecategory: json["attributecategory"] == null ? [] : List<Attributecategory>.from(json["attributecategory"]!.map((x) => Attributecategory.fromJson(x))),
    attributeName: json["attributeName"] == null ? null : AttributeName.fromJson(json["attributeName"]),
    orderId: json["orderId"],
    isOrder: json["isOrder"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceHubId": serviceHubId,
    "serviceBookingId": serviceBookingId,
    "storeId": storeId,
    "itemId": itemId,
    "userId": userId,
    "mrp": mrp,
    "calculatorPrice": calculatorPrice,
    "qty": qty,
    "CGST": cgst,
    "SGST": sgst,
    "IGST": igst,
    "commision": commision,
    "categoryId": categoryId,
    "projectId": projectId,
    "attributecategory": attributecategory == null ? [] : List<dynamic>.from(attributecategory!.map((x) => x.toJson())),
    "attributeName": attributeName?.toJson(),
    "orderId": orderId,
    "isOrder": isOrder,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class AttributeName {
  Attributecategory? the18;

  AttributeName({
    this.the18,
  });

  factory AttributeName.fromJson(Map<String, dynamic> json) => AttributeName(
    the18: json["18"] == null ? null : Attributecategory.fromJson(json["18"]),
  );

  Map<String, dynamic> toJson() => {
    "18": the18?.toJson(),
  };
}

class Attributecategory {
  String? label;
  int? value;

  Attributecategory({
    this.label,
    this.value,
  });

  factory Attributecategory.fromJson(Map<String, dynamic> json) => Attributecategory(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}

class ServiceHub {
  int? id;
  String? name;
  String? code;
  String? phoneNumber;

  ServiceHub({
    this.id,
    this.name,
    this.code,
    this.phoneNumber,
  });

  factory ServiceHub.fromJson(Map<String, dynamic> json) => ServiceHub(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
  };
}

class ServiceInspectionReport {
  int? id;
  int? serviceBookingId;
  int? serviceManId;
  String? toolsRequired;
  String? materialsRequired;
  String? workTobeDone;
  int? serviceChange;
  DateTime? createdAt;
  DateTime? updatedAt;

  ServiceInspectionReport({
    this.id,
    this.serviceBookingId,
    this.serviceManId,
    this.toolsRequired,
    this.materialsRequired,
    this.workTobeDone,
    this.serviceChange,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceInspectionReport.fromJson(Map<String, dynamic> json) => ServiceInspectionReport(
    id: json["id"],
    serviceBookingId: json["serviceBookingId"],
    serviceManId: json["serviceManId"],
    toolsRequired: json["toolsRequired"],
    materialsRequired: json["materialsRequired"],
    workTobeDone: json["workTobeDone"],
    serviceChange: json["serviceChange"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceBookingId": serviceBookingId,
    "serviceManId": serviceManId,
    "toolsRequired": toolsRequired,
    "materialsRequired": materialsRequired,
    "workTobeDone": workTobeDone,
    "serviceChange": serviceChange,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class UserAddress {
  int? id;
  int? userId;
  String? address;
  String? addressTitle;
  int? pinCode;
  String? location;
  String? name;
  String? phoneNumber;
  String? code;
  dynamic countryId;
  dynamic zoneId;
  dynamic clusterId;
  dynamic stateId;
  dynamic districtId;
  bool? isActive;
  bool? isDelete;
  bool? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserAddress({
    this.id,
    this.userId,
    this.address,
    this.addressTitle,
    this.pinCode,
    this.location,
    this.name,
    this.phoneNumber,
    this.code,
    this.countryId,
    this.zoneId,
    this.clusterId,
    this.stateId,
    this.districtId,
    this.isActive,
    this.isDelete,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
    id: json["id"],
    userId: json["userId"],
    address: json["address"],
    addressTitle: json["addressTitle"],
    pinCode: json["pinCode"],
    location: json["location"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    code: json["code"],
    countryId: json["countryId"],
    zoneId: json["zoneId"],
    clusterId: json["clusterId"],
    stateId: json["stateId"],
    districtId: json["districtId"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    isDefault: json["isDefault"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "address": address,
    "addressTitle": addressTitle,
    "pinCode": pinCode,
    "location": location,
    "name": name,
    "phoneNumber": phoneNumber,
    "code": code,
    "countryId": countryId,
    "zoneId": zoneId,
    "clusterId": clusterId,
    "stateId": stateId,
    "districtId": districtId,
    "isActive": isActive,
    "isDelete": isDelete,
    "isDefault": isDefault,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
