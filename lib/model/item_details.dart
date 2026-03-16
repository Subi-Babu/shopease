// To parse this JSON data, do
//
//     final itemListDetailsModel = itemListDetailsModelFromJson(jsonString);

import 'dart:convert';

ItemListDetailsModel itemListDetailsModelFromJson(String str) =>
    ItemListDetailsModel.fromJson(json.decode(str));

String itemListDetailsModelToJson(ItemListDetailsModel data) =>
    json.encode(data.toJson());

class ItemListDetailsModel {
  bool? status;
  String? message;
  Data? data;

  ItemListDetailsModel({this.status, this.message, this.data});

  factory ItemListDetailsModel.fromJson(Map<String, dynamic> json) =>
      ItemListDetailsModel(
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
  int? storeId;
  String? clusterName;
  int? storeItemId;
  int? id;
  String? name;
  String? description;
  String? itemId;
  bool? isTopSelling;
  dynamic gst;
  String? units;
  dynamic commision;
  dynamic mrp;
  dynamic basePrice;
  dynamic yourPrice;
  dynamic barCode;
  bool? isFeatured;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  ItemBrands? itemBrands;
  List<ItemCategory>? itemCategories;
  List<ItemAttributeCategory>? itemAttributeCategories;
  List<ItemStageCategory>? itemStageCategories;
  List<ItemImage>? itemImages;
  List<dynamic>? itemFiles;

  Data({
    this.storeId,
    this.clusterName,
    this.storeItemId,
    this.id,
    this.name,
    this.description,
    this.itemId,
    this.isTopSelling,
    this.gst,
    this.units,
    this.commision,
    this.mrp,
    this.basePrice,
    this.yourPrice,
    this.barCode,
    this.isFeatured,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.itemBrands,
    this.itemCategories,
    this.itemAttributeCategories,
    this.itemStageCategories,
    this.itemImages,
    this.itemFiles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    storeId: json["storeId"],
    clusterName: json["clusterName"],
    storeItemId: json["storeItemId"],
    id: json["id"],
    name: json["name"],
    description: json["description"],
    itemId: json["itemId"],
    isTopSelling: json["isTopSelling"],
    gst: json["gst"],
    units: json["units"],
    commision: json["commision"],
    mrp: json["mrp"],
    basePrice: json["basePrice"],
    yourPrice: json["yourPrice"],
    barCode: json["barCode"],
    isFeatured: json["isFeatured"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    itemBrands: json["itemBrands"] == null
        ? null
        : ItemBrands.fromJson(json["itemBrands"]),
    itemCategories: json["itemCategories"] == null
        ? []
        : List<ItemCategory>.from(
            json["itemCategories"]!.map((x) => ItemCategory.fromJson(x)),
          ),
    itemAttributeCategories: json["itemAttributeCategories"] == null
        ? []
        : List<ItemAttributeCategory>.from(
            json["itemAttributeCategories"]!.map(
              (x) => ItemAttributeCategory.fromJson(x),
            ),
          ),
    itemStageCategories: json["itemStageCategories"] == null
        ? []
        : List<ItemStageCategory>.from(
            json["itemStageCategories"]!.map(
              (x) => ItemStageCategory.fromJson(x),
            ),
          ),
    itemImages: json["itemImages"] == null
        ? []
        : List<ItemImage>.from(
            json["itemImages"]!.map((x) => ItemImage.fromJson(x)),
          ),
    itemFiles: json["itemFiles"] == null
        ? []
        : List<dynamic>.from(json["itemFiles"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "storeId": storeId,
    "clusterName": clusterName,
    "storeItemId": storeItemId,
    "id": id,
    "name": name,
    "description": description,
    "itemId": itemId,
    "isTopSelling": isTopSelling,
    "gst": gst,
    "units": units,
    "commision": commision,
    "mrp": mrp,
    "basePrice": basePrice,
    "yourPrice": yourPrice,
    "barCode": barCode,
    "isFeatured": isFeatured,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "itemBrands": itemBrands?.toJson(),
    "itemCategories": itemCategories == null
        ? []
        : List<dynamic>.from(itemCategories!.map((x) => x.toJson())),
    "itemAttributeCategories": itemAttributeCategories == null
        ? []
        : List<dynamic>.from(itemAttributeCategories!.map((x) => x.toJson())),
    "itemStageCategories": itemStageCategories == null
        ? []
        : List<dynamic>.from(itemStageCategories!.map((x) => x.toJson())),
    "itemImages": itemImages == null
        ? []
        : List<dynamic>.from(itemImages!.map((x) => x.toJson())),
    "itemFiles": itemFiles == null
        ? []
        : List<dynamic>.from(itemFiles!.map((x) => x)),
  };
}

class ItemAttributeCategory {
  int? id;
  int? attributeCategoryId;
  List<AttributeSubcategory>? attributeSubcategory;
  Brands? attributeCategory;

  ItemAttributeCategory({
    this.id,
    this.attributeCategoryId,
    this.attributeSubcategory,
    this.attributeCategory,
  });

  factory ItemAttributeCategory.fromJson(Map<String, dynamic> json) =>
      ItemAttributeCategory(
        id: json["id"],
        attributeCategoryId: json["attributeCategoryId"],
        attributeSubcategory: json["attributeSubcategory"] == null
            ? []
            : List<AttributeSubcategory>.from(
                json["attributeSubcategory"]!.map(
                  (x) => AttributeSubcategory.fromJson(x),
                ),
              ),
        attributeCategory: json["attributeCategory"] == null
            ? null
            : Brands.fromJson(json["attributeCategory"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributeCategoryId": attributeCategoryId,
    "attributeSubcategory": attributeSubcategory == null
        ? []
        : List<dynamic>.from(attributeSubcategory!.map((x) => x.toJson())),
    "attributeCategory": attributeCategory?.toJson(),
  };
}

class Brands {
  int? id;
  String? name;

  Brands({this.id, this.name});

  factory Brands.fromJson(Map<String, dynamic> json) =>
      Brands(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class AttributeSubcategory {
  String? mrp;
  String? label;
  int? value;
  String? basePrice;

  AttributeSubcategory({this.mrp, this.label, this.value, this.basePrice});

  factory AttributeSubcategory.fromJson(Map<String, dynamic> json) =>
      AttributeSubcategory(
        mrp: json["mrp"],
        label: json["label"],
        value: json["value"],
        basePrice: json["basePrice"],
      );

  Map<String, dynamic> toJson() => {
    "mrp": mrp,
    "label": label,
    "value": value,
    "basePrice": basePrice,
  };
}

class ItemBrands {
  int? id;
  int? brandId;
  Brands? brands;

  ItemBrands({this.id, this.brandId, this.brands});

  factory ItemBrands.fromJson(Map<String, dynamic> json) => ItemBrands(
    id: json["id"],
    brandId: json["brandId"],
    brands: json["brands"] == null ? null : Brands.fromJson(json["brands"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brandId": brandId,
    "brands": brands?.toJson(),
  };
}

class ItemCategory {
  int? id;
  int? categoryId;
  Brands? category;

  ItemCategory({this.id, this.categoryId, this.category});

  factory ItemCategory.fromJson(Map<String, dynamic> json) => ItemCategory(
    id: json["id"],
    categoryId: json["categoryId"],
    category: json["category"] == null
        ? null
        : Brands.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryId": categoryId,
    "category": category?.toJson(),
  };
}

class ItemImage {
  int? id;
  String? image;
  String? fileName;

  ItemImage({this.id, this.image, this.fileName});

  factory ItemImage.fromJson(Map<String, dynamic> json) => ItemImage(
    id: json["id"],
    image: json["Image"],
    fileName: json["fileName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Image": image,
    "fileName": fileName,
  };
}

class ItemStageCategory {
  int? id;
  int? stageCategoryId;
  Brands? stageCategory;

  ItemStageCategory({this.id, this.stageCategoryId, this.stageCategory});

  factory ItemStageCategory.fromJson(Map<String, dynamic> json) =>
      ItemStageCategory(
        id: json["id"],
        stageCategoryId: json["stageCategoryId"],
        stageCategory: json["stageCategory"] == null
            ? null
            : Brands.fromJson(json["stageCategory"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "stageCategoryId": stageCategoryId,
    "stageCategory": stageCategory?.toJson(),
  };
}
