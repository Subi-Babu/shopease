// To parse this JSON data, do
//
//     final itemListModel = itemListModelFromJson(jsonString);

import 'dart:convert';

ItemListModel itemListModelFromJson(String str) =>
    ItemListModel.fromJson(json.decode(str));

String itemListModelToJson(ItemListModel data) => json.encode(data.toJson());

class ItemListModel {
  bool? status;
  String? message;
  int? page;
  int? totalPages;
  int? totalitemList;
  List<ItemList>? itemList;

  ItemListModel({
    this.status,
    this.message,
    this.page,
    this.totalPages,
    this.totalitemList,
    this.itemList,
  });

  factory ItemListModel.fromJson(Map<String, dynamic> json) => ItemListModel(
    status: json["status"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    totalitemList: json["totalitemList"],
    itemList: json["itemList"] == null
        ? []
        : List<ItemList>.from(
            json["itemList"]!.map((x) => ItemList.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "totalitemList": totalitemList,
    "itemList": itemList == null
        ? []
        : List<dynamic>.from(itemList!.map((x) => x.toJson())),
  };
}

class ItemList {
  int? storeId;
  int? mrp;
  int? basePrice;
  int? yourPrice;
  int? id;
  int? itemId;
  String? name;
  String? description;
  bool? isFeatured;
  bool? isTopSelling;
  double? commision;
  int? gst;
  int? barCode;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  List<ItemImage>? itemImages;
  List<ItemBrand>? itemBrands;
  List<ItemCategory>? itemCategories;
  List<ItemStageCategory>? itemStageCategories;
  List<ItemAttributeCategory>? itemAttributeCategories;
  List<Attribute>? attributecategory;
  Map<String, Attribute>? attributeName;

  ItemList({
    this.storeId,
    this.mrp,
    this.basePrice,
    this.yourPrice,
    this.id,
    this.itemId,
    this.name,
    this.description,
    this.isFeatured,
    this.isTopSelling,
    this.commision,
    this.gst,
    this.barCode,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.itemImages,
    this.itemBrands,
    this.itemCategories,
    this.itemStageCategories,
    this.itemAttributeCategories,
    this.attributecategory,
    this.attributeName,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
    storeId: json["storeId"],
    mrp: json["mrp"],
    basePrice: json["basePrice"],
    yourPrice: json["yourPrice"],
    id: json["id"],
    itemId: json["itemId"],
    name: json["name"],
    description: json["description"],
    isFeatured: json["isFeatured"],
    isTopSelling: json["isTopSelling"],
    commision: json["commision"]?.toDouble(),
    gst: json["gst"],
    barCode: json["barCode"],
    isActive: json["isActive"],
    isDelete: json["isDelete"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    itemImages: json["itemImages"] == null
        ? []
        : List<ItemImage>.from(
            json["itemImages"]!.map((x) => ItemImage.fromJson(x)),
          ),
    itemBrands: json["itemBrands"] == null
        ? []
        : List<ItemBrand>.from(
            json["itemBrands"]!.map((x) => ItemBrand.fromJson(x)),
          ),
    itemCategories: json["itemCategories"] == null
        ? []
        : List<ItemCategory>.from(
            json["itemCategories"]!.map((x) => ItemCategory.fromJson(x)),
          ),
    itemStageCategories: json["itemStageCategories"] == null
        ? []
        : List<ItemStageCategory>.from(
            json["itemStageCategories"]!.map(
              (x) => ItemStageCategory.fromJson(x),
            ),
          ),
    itemAttributeCategories: json["itemAttributeCategories"] == null
        ? []
        : List<ItemAttributeCategory>.from(
            json["itemAttributeCategories"]!.map(
              (x) => ItemAttributeCategory.fromJson(x),
            ),
          ),
    attributecategory: json["attributecategory"] == null
        ? []
        : List<Attribute>.from(
            json["attributecategory"]!.map((x) => Attribute.fromJson(x)),
          ),
    attributeName: json["attributeName"] == null
        ? {}
        : Map<String, Attribute>.from(
            json["attributeName"].map(
              (k, v) => MapEntry(k, Attribute.fromJson(v)),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    "storeId": storeId,
    "mrp": mrp,
    "basePrice": basePrice,
    "yourPrice": yourPrice,
    "id": id,
    "itemId": itemId,
    "name": name,
    "description": description,
    "isFeatured": isFeatured,
    "isTopSelling": isTopSelling,
    "commision": commision,
    "gst": gst,
    "barCode": barCode,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "itemImages": itemImages == null
        ? []
        : List<dynamic>.from(itemImages!.map((x) => x.toJson())),
    "itemBrands": itemBrands == null
        ? []
        : List<dynamic>.from(itemBrands!.map((x) => x.toJson())),
    "itemCategories": itemCategories == null
        ? []
        : List<dynamic>.from(itemCategories!.map((x) => x.toJson())),
    "itemStageCategories": itemStageCategories == null
        ? []
        : List<dynamic>.from(itemStageCategories!.map((x) => x.toJson())),
    "itemAttributeCategories": itemAttributeCategories == null
        ? []
        : List<dynamic>.from(itemAttributeCategories!.map((x) => x.toJson())),
    "attributecategory": attributecategory == null
        ? []
        : List<dynamic>.from(attributecategory!.map((x) => x.toJson())),
    "attributeName": Map.from(
      attributeName!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Attribute {
  String? label;
  int? value;

  Attribute({this.label, this.value});

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      Attribute(label: json["label"], value: json["value"]);

  Map<String, dynamic> toJson() => {"label": label, "value": value};
}

class ItemAttributeCategory {
  int? id;
  int? attributeCategoryId;
  List<AttributeSubcategory>? attributeSubcategory;
  AttributeCategory? attributeCategory;

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
            : AttributeCategory.fromJson(json["attributeCategory"]),
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

class AttributeCategory {
  int? id;
  String? name;

  AttributeCategory({this.id, this.name});

  factory AttributeCategory.fromJson(Map<String, dynamic> json) =>
      AttributeCategory(id: json["id"], name: json["name"]);

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

class ItemBrand {
  int? id;
  int? brandId;
  AttributeCategory? brands;

  ItemBrand({this.id, this.brandId, this.brands});

  factory ItemBrand.fromJson(Map<String, dynamic> json) => ItemBrand(
    id: json["id"],
    brandId: json["brandId"],
    brands: json["brands"] == null
        ? null
        : AttributeCategory.fromJson(json["brands"]),
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
  Category? category;

  ItemCategory({this.id, this.categoryId, this.category});

  factory ItemCategory.fromJson(Map<String, dynamic> json) => ItemCategory(
    id: json["id"],
    categoryId: json["categoryId"],
    category: json["category"] == null
        ? null
        : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryId": categoryId,
    "category": category?.toJson(),
  };
}

class Category {
  int? id;
  String? name;
  List<SubCategory>? subCategories;

  Category({this.id, this.name, this.subCategories});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    subCategories: json["subCategories"] == null
        ? []
        : List<SubCategory>.from(
            json["subCategories"]!.map((x) => SubCategory.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "subCategories": subCategories == null
        ? []
        : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
  };
}

class SubCategory {
  int? id;
  String? name;
  String? image;
  FileName? fileName;
  int? size;
  int? categoryId;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubCategory({
    this.id,
    this.name,
    this.image,
    this.fileName,
    this.size,
    this.categoryId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    name: json["name"],
    image: json["Image"],
    fileName: fileNameValues.map[json["fileName"]]!,
    size: json["size"],
    categoryId: json["categoryId"],
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
    "name": name,
    "Image": image,
    "fileName": fileNameValues.reverse[fileName],
    "size": size,
    "categoryId": categoryId,
    "isActive": isActive,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

enum FileName {
  IMAGE_12702733805_JPG,
  THE_1764846326621_LOGO_YOUBUILT_PNG,
  THE_1765004165259_LOGOICON_PNG,
}

final fileNameValues = EnumValues({
  "image_1270273380_5.jpg": FileName.IMAGE_12702733805_JPG,
  "1764846326621-Logo Youbuilt.png":
      FileName.THE_1764846326621_LOGO_YOUBUILT_PNG,
  "1765004165259-logoicon.png": FileName.THE_1765004165259_LOGOICON_PNG,
});

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
  AttributeCategory? stageCategory;

  ItemStageCategory({this.id, this.stageCategoryId, this.stageCategory});

  factory ItemStageCategory.fromJson(Map<String, dynamic> json) =>
      ItemStageCategory(
        id: json["id"],
        stageCategoryId: json["stageCategoryId"],
        stageCategory: json["stageCategory"] == null
            ? null
            : AttributeCategory.fromJson(json["stageCategory"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "stageCategoryId": stageCategoryId,
    "stageCategory": stageCategory?.toJson(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
