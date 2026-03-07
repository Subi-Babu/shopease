// To parse this JSON data, do
//
//     final orderViewModel = orderViewModelFromJson(jsonString);

import 'dart:convert';

OrderViewModel orderViewModelFromJson(String str) =>
    OrderViewModel.fromJson(json.decode(str));

String orderViewModelToJson(OrderViewModel data) => json.encode(data.toJson());

class OrderViewModel {
  bool? status;
  String? message;
  Data? data;

  OrderViewModel({this.status, this.message, this.data});

  factory OrderViewModel.fromJson(Map<String, dynamic> json) => OrderViewModel(
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
  int? userId;
  String? orderId;
  int? userAddressId;
  dynamic totalPrice;
  dynamic totalcalculatorPrice;
  dynamic grandTotal;
  dynamic discount;
  dynamic paidAmount;
  dynamic pendingAmount;
  UserAddress? userAddress;
  Users? users;
  dynamic projects;
  List<OrderItem>? orderItems;
  dynamic totalGst;
  dynamic totalCommision;

  Data({
    this.userId,
    this.orderId,
    this.userAddressId,
    this.totalPrice,
    this.totalcalculatorPrice,
    this.grandTotal,
    this.discount,
    this.paidAmount,
    this.pendingAmount,
    this.userAddress,
    this.users,
    this.projects,
    this.orderItems,
    this.totalGst,
    this.totalCommision,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["userId"],
    orderId: json["orderId"],
    userAddressId: json["userAddressId"],
    totalPrice: json["totalPrice"],
    totalcalculatorPrice: json["totalcalculatorPrice"],
    grandTotal: json["grandTotal"],
    discount: json["discount"],
    paidAmount: json["paidAmount"],
    pendingAmount: json["pendingAmount"],
    userAddress: json["userAddress"] == null
        ? null
        : UserAddress.fromJson(json["userAddress"]),
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    projects: json["projects"],
    orderItems: json["orderItems"] == null
        ? []
        : List<OrderItem>.from(
            json["orderItems"]!.map((x) => OrderItem.fromJson(x)),
          ),
    totalGst: json["totalGST"],
    totalCommision: json["totalCommision"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "orderId": orderId,
    "userAddressId": userAddressId,
    "totalPrice": totalPrice,
    "totalcalculatorPrice": totalcalculatorPrice,
    "grandTotal": grandTotal,
    "discount": discount,
    "paidAmount": paidAmount,
    "pendingAmount": pendingAmount,
    "userAddress": userAddress?.toJson(),
    "users": users?.toJson(),
    "projects": projects,
    "orderItems": orderItems == null
        ? []
        : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
    "totalGST": totalGst,
    "totalCommision": totalCommision,
  };
}

class OrderItem {
  int? id;
  int? storeId;
  int? itemId;
  int? mrp;
  int? calculatorPrice;
  int? qty;
  int? categoryId;
  dynamic igst;
  dynamic sgst;
  dynamic cgst;
  dynamic commision;
  List<dynamic>? attributecategory;
  AttributeName? attributeName;
  Store? store;
  Item? item;

  OrderItem({
    this.id,
    this.storeId,
    this.itemId,
    this.mrp,
    this.calculatorPrice,
    this.qty,
    this.categoryId,
    this.igst,
    this.sgst,
    this.cgst,
    this.commision,
    this.attributecategory,
    this.attributeName,
    this.store,
    this.item,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    storeId: json["storeId"],
    itemId: json["itemId"],
    mrp: json["mrp"],
    calculatorPrice: json["calculatorPrice"],
    qty: json["qty"],
    categoryId: json["categoryId"],
    igst: json["IGST"],
    sgst: json["SGST"],
    cgst: json["CGST"],
    commision: json["commision"],
    attributecategory: json["attributecategory"] == null
        ? []
        : List<dynamic>.from(json["attributecategory"]!.map((x) => x)),
    attributeName: json["attributeName"] == null
        ? null
        : AttributeName.fromJson(json["attributeName"]),
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "storeId": storeId,
    "itemId": itemId,
    "mrp": mrp,
    "calculatorPrice": calculatorPrice,
    "qty": qty,
    "categoryId": categoryId,
    "IGST": igst,
    "SGST": sgst,
    "CGST": cgst,
    "commision": commision,
    "attributecategory": attributecategory == null
        ? []
        : List<dynamic>.from(attributecategory!.map((x) => x)),
    "attributeName": attributeName?.toJson(),
    "store": store?.toJson(),
    "item": item?.toJson(),
  };
}

class AttributeName {
  AttributeName();

  factory AttributeName.fromJson(Map<String, dynamic> json) => AttributeName();

  Map<String, dynamic> toJson() => {};
}

class Item {
  int? id;
  String? name;
  String? units;
  int? gst;
  String? description;
  List<ItemImage>? itemImages;

  Item({
    this.id,
    this.name,
    this.units,
    this.gst,
    this.description,
    this.itemImages,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    units: json["units"],
    gst: json["gst"],
    description: json["description"],
    itemImages: json["itemImages"] == null
        ? []
        : List<ItemImage>.from(
            json["itemImages"]!.map((x) => ItemImage.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "units": units,
    "gst": gst,
    "description": description,
    "itemImages": itemImages == null
        ? []
        : List<dynamic>.from(itemImages!.map((x) => x.toJson())),
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
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
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
  String? address1;
  String? address2;
  int? zipCode;
  String? location;
  Cluster? country;
  Cluster? zone;
  Cluster? cluster;
  Cluster? states;
  Cluster? district;

  Store({
    this.id,
    this.address1,
    this.address2,
    this.zipCode,
    this.location,
    this.country,
    this.zone,
    this.cluster,
    this.states,
    this.district,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
    address1: json["address1"],
    address2: json["address2"],
    zipCode: json["zipCode"],
    location: json["location"],
    country: json["country"] == null ? null : Cluster.fromJson(json["country"]),
    zone: json["zone"] == null ? null : Cluster.fromJson(json["zone"]),
    cluster: json["cluster"] == null ? null : Cluster.fromJson(json["cluster"]),
    states: json["states"] == null ? null : Cluster.fromJson(json["states"]),
    district: json["district"] == null
        ? null
        : Cluster.fromJson(json["district"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address1": address1,
    "address2": address2,
    "zipCode": zipCode,
    "location": location,
    "country": country?.toJson(),
    "zone": zone?.toJson(),
    "cluster": cluster?.toJson(),
    "states": states?.toJson(),
    "district": district?.toJson(),
  };
}

class Cluster {
  int? id;
  String? name;

  Cluster({this.id, this.name});

  factory Cluster.fromJson(Map<String, dynamic> json) =>
      Cluster(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
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
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
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
  String? code;
  String? phoneNumber;

  Users({this.id, this.name, this.code, this.phoneNumber});

  factory Users.fromJson(Map<String, dynamic> json) => Users(
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
