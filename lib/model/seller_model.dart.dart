// To parse this JSON data, do
//
//     final sellerModel = sellerModelFromJson(jsonString);

import 'dart:convert';

SellerModel sellerModelFromJson(String str) => SellerModel.fromJson(json.decode(str));

String sellerModelToJson(SellerModel data) => json.encode(data.toJson());

class SellerModel {
  bool? status;
  String? message;
  List<Datum>? data;

  SellerModel({
    this.status,
    this.message,
    this.data,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
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
  int? storeId;
  int? itemId;
  int? mrp;
  int? basePrice;
  int? yourPrice;
  Item? item;
  Store? store;
  double? totalGst;

  Datum({
    this.storeId,
    this.itemId,
    this.mrp,
    this.basePrice,
    this.yourPrice,
    this.item,
    this.store,
    this.totalGst,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    storeId: json["storeId"],
    itemId: json["itemId"],
    mrp: json["mrp"],
    basePrice: json["basePrice"],
    yourPrice: json["yourPrice"],
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    totalGst: json["totalGst"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "storeId": storeId,
    "itemId": itemId,
    "mrp": mrp,
    "basePrice": basePrice,
    "yourPrice": yourPrice,
    "item": item?.toJson(),
    "store": store?.toJson(),
    "totalGst": totalGst,
  };
}

class Item {
  int? id;
  int? gst;
  String? units;

  Item({
    this.id,
    this.gst,
    this.units,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    gst: json["gst"],
    units: json["units"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gst": gst,
    "units": units,
  };
}

class Store {
  int? id;
  Cluster? cluster;

  Store({
    this.id,
    this.cluster,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
    cluster: json["cluster"] == null ? null : Cluster.fromJson(json["cluster"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cluster": cluster?.toJson(),
  };
}

class Cluster {
  int? id;
  String? name;

  Cluster({
    this.id,
    this.name,
  });

  factory Cluster.fromJson(Map<String, dynamic> json) => Cluster(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
