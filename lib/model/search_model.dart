// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  bool? status;
  String? message;
  int? page;
  int? totalPages;
  int? totalitemList;
  List<ItemListElement>? itemList;
  List<ItemListElement>? serviceList;
  int? servicetotalPages;

  SearchModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.totalitemList,
    this.itemList,
    this.serviceList,
    this.servicetotalPages,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    status: json["status"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    totalitemList: json["totalitemList"],
    itemList: json["itemList"] == null ? [] : List<ItemListElement>.from(json["itemList"]!.map((x) => ItemListElement.fromJson(x))),
    serviceList: json["serviceList"] == null ? [] : List<ItemListElement>.from(json["serviceList"]!.map((x) => ItemListElement.fromJson(x))),
    servicetotalPages: json["ServicetotalPages"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "totalitemList": totalitemList,
    "itemList": itemList == null ? [] : List<dynamic>.from(itemList!.map((x) => x.toJson())),
    "serviceList": serviceList == null ? [] : List<dynamic>.from(serviceList!.map((x) => x.toJson())),
    "ServicetotalPages": servicetotalPages,
  };
}

class ItemListElement {
  int? id;
  int? itemId;
  String? name;
  String? description;
  String? image;

  ItemListElement({
    this.id,
    this.itemId,
    this.name,
    this.description,
    this.image,
  });

  factory ItemListElement.fromJson(Map<String, dynamic> json) => ItemListElement(
    id: json["id"],
    itemId: json["itemId"],
    name: json["name"],
    description: json["description"],
    image: json["Image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "itemId": itemId,
    "name": name,
    "description": description,
    "Image": image,
  };
}
