// To parse this JSON data, do
//
//     final cartListModel = cartListModelFromJson(jsonString);

import 'dart:convert';

CartListModel cartListModelFromJson(String str) =>
    CartListModel.fromJson(json.decode(str));

String cartListModelToJson(CartListModel data) => json.encode(data.toJson());

class CartListModel {
  bool? status;
  String? message;
  List<Datum>? data;

  CartListModel({this.status, this.message, this.data});

  factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? storeId;
  int? itemId;
  int? userId;
  dynamic mrp;
  dynamic calculatorPrice;
  int? qty;
  int? categoryId;
  dynamic projectId;
  List<dynamic>? attributecategory;
  AttributeName? attributeName;
  Store? store;
  Store? users;
  Item? item;
  dynamic projects;
  dynamic totalGst;

  Datum({
    this.id,
    this.storeId,
    this.itemId,
    this.userId,
    this.mrp,
    this.calculatorPrice,
    this.qty,
    this.categoryId,
    this.projectId,
    this.attributecategory,
    this.attributeName,
    this.store,
    this.users,
    this.item,
    this.projects,
    this.totalGst,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    storeId: json["storeId"],
    itemId: json["itemId"],
    userId: json["userId"],
    mrp: json["mrp"],
    calculatorPrice: json["calculatorPrice"],
    qty: json["qty"],
    categoryId: json["categoryId"],
    projectId: json["projectId"],
    attributecategory: json["attributecategory"] == null
        ? []
        : List<dynamic>.from(json["attributecategory"]!.map((x) => x)),
    attributeName: json["attributeName"] == null
        ? null
        : AttributeName.fromJson(json["attributeName"]),
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    users: json["users"] == null ? null : Store.fromJson(json["users"]),
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    projects: json["projects"],
    totalGst: json["totalGst"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "storeId": storeId,
    "itemId": itemId,
    "userId": userId,
    "mrp": mrp,
    "calculatorPrice": calculatorPrice,
    "qty": qty,
    "categoryId": categoryId,
    "projectId": projectId,
    "attributecategory": attributecategory == null
        ? []
        : List<dynamic>.from(attributecategory!.map((x) => x)),
    "attributeName": attributeName?.toJson(),
    "store": store?.toJson(),
    "users": users?.toJson(),
    "item": item?.toJson(),
    "projects": projects,
    "totalGst": totalGst,
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
  List<ItemImage>? itemImages;
  dynamic gst;

  Item({this.id, this.name, this.itemImages, this.gst});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    itemImages: json["itemImages"] == null
        ? []
        : List<ItemImage>.from(
            json["itemImages"]!.map((x) => ItemImage.fromJson(x)),
          ),
    gst: json["gst"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "itemImages": itemImages == null
        ? []
        : List<dynamic>.from(itemImages!.map((x) => x.toJson())),
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
  String? name;

  Store({this.id, this.name});

  factory Store.fromJson(Map<String, dynamic> json) =>
      Store(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
