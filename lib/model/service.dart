// To parse this JSON data, do
//
//     final serviceDetailsModelNew = serviceDetailsModelNewFromJson(jsonString);

import 'dart:convert';

ServiceDetailsModelNew serviceDetailsModelNewFromJson(String str) => ServiceDetailsModelNew.fromJson(json.decode(str));

String serviceDetailsModelNewToJson(ServiceDetailsModelNew data) => json.encode(data.toJson());

class ServiceDetailsModelNew {
  bool? status;
  String? message;
  Data? data;

  ServiceDetailsModelNew({
    this.status,
    this.message,
    this.data,
  });

  factory ServiceDetailsModelNew.fromJson(Map<String, dynamic> json) => ServiceDetailsModelNew(
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
  String? serviceBookingId;
  int? userId;
  int? serviceId;
  int? serviceHubId;
  int? userAddressId;
  dynamic grandTotal;
  dynamic discount;
  dynamic invoiceAmount;
  String? isMaterialPurchase;
  String? status;
  String? serviceManstatus;
  String? paymentStatus;
  dynamic paidAmount;
  dynamic pendingAmount;
  dynamic gst;
  dynamic igst;
  dynamic cgst;
  dynamic sgst;
  dynamic commision;
  dynamic commisionTax;
  String? serviceManUrl;
  String? workTobeDone;
  String? name;
  String? code;
  String? phoneNumber;
  DateTime? date;
  String? message;
  dynamic fileName;
  dynamic file;
  dynamic size;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  UserAddress? userAddress;
  dynamic projectId;
  dynamic orderId;
  dynamic order;
  dynamic projects;
  int? serviceManId;
  ServiceHubClass? serviceMan;
  ServiceHubClass? serviceHub;
  Users? users;
  Service? service;
  List<ServiceCart>? serviceCarts;
  List<dynamic>? serviceBookingTransactions;
  List<ServiceInspectionReport>? serviceInspectionReports;

  Data({
    this.id,
    this.serviceBookingId,
    this.userId,
    this.serviceId,
    this.serviceHubId,
    this.userAddressId,
    this.grandTotal,
    this.discount,
    this.invoiceAmount,
    this.isMaterialPurchase,
    this.status,
    this.serviceManstatus,
    this.paymentStatus,
    this.paidAmount,
    this.pendingAmount,
    this.gst,
    this.igst,
    this.cgst,
    this.sgst,
    this.commision,
    this.commisionTax,
    this.serviceManUrl,
    this.workTobeDone,
    this.name,
    this.code,
    this.phoneNumber,
    this.date,
    this.message,
    this.fileName,
    this.file,
    this.size,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.userAddress,
    this.projectId,
    this.orderId,
    this.order,
    this.projects,
    this.serviceManId,
    this.serviceMan,
    this.serviceHub,
    this.users,
    this.service,
    this.serviceCarts,
    this.serviceBookingTransactions,
    this.serviceInspectionReports,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    serviceBookingId: json["serviceBookingId"],
    userId: json["userId"],
    serviceId: json["serviceId"],
    serviceHubId: json["serviceHubId"],
    userAddressId: json["userAddressId"],
    grandTotal: json["grandTotal"],
    discount: json["discount"],
    invoiceAmount: json["invoiceAmount"],
    isMaterialPurchase: json["isMaterialPurchase"],
    status: json["status"],
    serviceManstatus: json["serviceManstatus"],
    paymentStatus: json["paymentStatus"],
    paidAmount: json["paidAmount"],
    pendingAmount: json["pendingAmount"],
    gst: json["gst"],
    igst: json["IGST"],
    cgst: json["CGST"],
    sgst: json["SGST"],
    commision: json["commision"],
    commisionTax: json["commisionTax"],
    serviceManUrl: json["serviceManURL"],
    workTobeDone: json["workTobeDone"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    message: json["message"],
    fileName: json["fileName"],
    file: json["file"],
    size: json["size"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    userAddress: json["userAddress"] == null ? null : UserAddress.fromJson(json["userAddress"]),
    projectId: json["projectId"],
    orderId: json["orderId"],
    order: json["order"],
    projects: json["projects"],
    serviceManId: json["serviceManId"],
    serviceMan: json["serviceMan"] == null ? null : ServiceHubClass.fromJson(json["serviceMan"]),
    serviceHub: json["serviceHub"] == null ? null : ServiceHubClass.fromJson(json["serviceHub"]),
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    serviceCarts: json["serviceCarts"] == null ? [] : List<ServiceCart>.from(json["serviceCarts"]!.map((x) => ServiceCart.fromJson(x))),
    serviceBookingTransactions: json["serviceBookingTransactions"] == null ? [] : List<dynamic>.from(json["serviceBookingTransactions"]!.map((x) => x)),
    serviceInspectionReports: json["serviceInspectionReports"] == null ? [] : List<ServiceInspectionReport>.from(json["serviceInspectionReports"]!.map((x) => ServiceInspectionReport.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceBookingId": serviceBookingId,
    "userId": userId,
    "serviceId": serviceId,
    "serviceHubId": serviceHubId,
    "userAddressId": userAddressId,
    "grandTotal": grandTotal,
    "discount": discount,
    "invoiceAmount": invoiceAmount,
    "isMaterialPurchase": isMaterialPurchase,
    "status": status,
    "serviceManstatus": serviceManstatus,
    "paymentStatus": paymentStatus,
    "paidAmount": paidAmount,
    "pendingAmount": pendingAmount,
    "gst": gst,
    "IGST": igst,
    "CGST": cgst,
    "SGST": sgst,
    "commision": commision,
    "commisionTax": commisionTax,
    "serviceManURL": serviceManUrl,
    "workTobeDone": workTobeDone,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
    "date": date?.toIso8601String(),
    "message": message,
    "fileName": fileName,
    "file": file,
    "size": size,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "userAddress": userAddress?.toJson(),
    "projectId": projectId,
    "orderId": orderId,
    "order": order,
    "projects": projects,
    "serviceManId": serviceManId,
    "serviceMan": serviceMan?.toJson(),
    "serviceHub": serviceHub?.toJson(),
    "users": users?.toJson(),
    "service": service?.toJson(),
    "serviceCarts": serviceCarts == null ? [] : List<dynamic>.from(serviceCarts!.map((x) => x.toJson())),
    "serviceBookingTransactions": serviceBookingTransactions == null ? [] : List<dynamic>.from(serviceBookingTransactions!.map((x) => x)),
    "serviceInspectionReports": serviceInspectionReports == null ? [] : List<dynamic>.from(serviceInspectionReports!.map((x) => x.toJson())),
  };
}

class Service {
  int? id;
  String? name;
  String? image;
  ServiceCategory? serviceCategory;

  Service({
    this.id,
    this.name,
    this.image,
    this.serviceCategory,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
    serviceCategory: json["serviceCategory"] == null ? null : ServiceCategory.fromJson(json["serviceCategory"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "Image": image,
    "serviceCategory": serviceCategory?.toJson(),
  };
}

class ServiceCategory {
  int? id;
  String? name;

  ServiceCategory({
    this.id,
    this.name,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) => ServiceCategory(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class ServiceCart {
  int? id;
  int? storeId;
  int? itemId;
  int? userId;
  int? serviceBookingId;
  dynamic mrp;
  int? serviceHubId;
  dynamic calculatorPrice;
  dynamic qty;
  dynamic igst;
  dynamic sgst;
  dynamic cgst;
  dynamic commision;
  int? categoryId;
  dynamic projectId;
  List<Attribute>? attributecategory;
  Map<String, Attribute>? attributeName;
  Store? store;
  ServiceCategory? users;
  Item? item;
  dynamic projects;

  ServiceCart({
    this.id,
    this.storeId,
    this.itemId,
    this.userId,
    this.serviceBookingId,
    this.mrp,
    this.serviceHubId,
    this.calculatorPrice,
    this.qty,
    this.igst,
    this.sgst,
    this.cgst,
    this.commision,
    this.categoryId,
    this.projectId,
    this.attributecategory,
    this.attributeName,
    this.store,
    this.users,
    this.item,
    this.projects,
  });

  factory ServiceCart.fromJson(Map<String, dynamic> json) => ServiceCart(
    id: json["id"],
    storeId: json["storeId"],
    itemId: json["itemId"],
    userId: json["userId"],
    serviceBookingId: json["serviceBookingId"],
    mrp: json["mrp"],
    serviceHubId: json["serviceHubId"],
    calculatorPrice: json["calculatorPrice"],
    qty: json["qty"],
    igst: json["IGST"]?.toDouble(),
    sgst: json["SGST"],
    cgst: json["CGST"],
    commision: json["commision"]?.toDouble(),
    categoryId: json["categoryId"],
    projectId: json["projectId"],
    attributecategory: json["attributecategory"] == null ? [] : List<Attribute>.from(json["attributecategory"]!.map((x) => Attribute.fromJson(x))),
    attributeName: Map.from(json["attributeName"]!).map((k, v) => MapEntry<String, Attribute>(k, Attribute.fromJson(v))),
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    users: json["users"] == null ? null : ServiceCategory.fromJson(json["users"]),
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    projects: json["projects"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "storeId": storeId,
    "itemId": itemId,
    "userId": userId,
    "serviceBookingId": serviceBookingId,
    "mrp": mrp,
    "serviceHubId": serviceHubId,
    "calculatorPrice": calculatorPrice,
    "qty": qty,
    "IGST": igst,
    "SGST": sgst,
    "CGST": cgst,
    "commision": commision,
    "categoryId": categoryId,
    "projectId": projectId,
    "attributecategory": attributecategory == null ? [] : List<dynamic>.from(attributecategory!.map((x) => x.toJson())),
    "attributeName": Map.from(attributeName!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "store": store?.toJson(),
    "users": users?.toJson(),
    "item": item?.toJson(),
    "projects": projects,
  };
}

class Attribute {
  String? label;
  int? value;

  Attribute({
    this.label,
    this.value,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}

class Item {
  int? id;
  String? name;
  String? units;
  List<ItemImage>? itemImages;
  dynamic gst;

  Item({
    this.id,
    this.name,
    this.units,
    this.itemImages,
    this.gst,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    units: json["units"],
    itemImages: json["itemImages"] == null ? [] : List<ItemImage>.from(json["itemImages"]!.map((x) => ItemImage.fromJson(x))),
    gst: json["gst"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "units": units,
    "itemImages": itemImages == null ? [] : List<dynamic>.from(itemImages!.map((x) => x.toJson())),
    "gst": gst,
  };
}

class ItemImage {
  int? id;
  String? image;
  String? fileName;
  int? size;
  int? itemId;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  ItemImage({
    this.id,
    this.image,
    this.fileName,
    this.size,
    this.itemId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemImage.fromJson(Map<String, dynamic> json) => ItemImage(
    id: json["id"],
    image: json["Image"],
    fileName: json["fileName"],
    size: json["size"],
    itemId: json["itemId"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Image": image,
    "fileName": fileName,
    "size": size,
    "itemId": itemId,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Store {
  int? id;

  Store({
    this.id,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

class ServiceHubClass {
  int? id;
  String? name;
  String? code;
  String? phoneNumber;
  String? serviceHubId;

  ServiceHubClass({
    this.id,
    this.name,
    this.code,
    this.phoneNumber,
    this.serviceHubId,
  });

  factory ServiceHubClass.fromJson(Map<String, dynamic> json) => ServiceHubClass(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    serviceHubId: json["serviceHubId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "phoneNumber": phoneNumber,
    "serviceHubId": serviceHubId,
  };
}

class ServiceInspectionReport {
  int? id;
  int? serviceBookingId;
  int? serviceManId;
  String? toolsRequired;
  String? materialsRequired;
  String? workTobeDone;
  dynamic serviceChange;
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
  dynamic code;
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

class Users {
  int? id;
  String? name;
  String? cuId;

  Users({
    this.id,
    this.name,
    this.cuId,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    cuId: json["cuId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cuId": cuId,
  };
}

