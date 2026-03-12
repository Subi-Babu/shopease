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

  ItemListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    page = json['page'];
    totalPages = json['totalPages'];
    totalitemList = json['totalitemList'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['page'] = this.page;
    data['totalPages'] = this.totalPages;
    data['totalitemList'] = this.totalitemList;
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  int? id;
  int? storeId;
  String? storeName;
  dynamic mrp;
  dynamic basePrice;
  dynamic yourPrice;
  int? itemId;
  List<Attributecategory>? attributecategory;
  AttributeName? attributeName;
  Item? item;
  dynamic totalGst;

  ItemList({
    this.id,
    this.storeId,
    this.storeName,
    this.mrp,
    this.basePrice,
    this.yourPrice,
    this.itemId,
    this.attributecategory,
    this.attributeName,
    this.item,
    this.totalGst,
  });

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    mrp = json['mrp'];
    basePrice = json['basePrice'];
    yourPrice = json['yourPrice'];
    itemId = json['itemId'];
    if (json['attributecategory'] != null) {
      attributecategory = <Attributecategory>[];
      json['attributecategory'].forEach((v) {
        attributecategory!.add(new Attributecategory.fromJson(v));
      });
    }
    attributeName = json['attributeName'] != null
        ? new AttributeName.fromJson(json['attributeName'])
        : null;
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    totalGst = json['totalGst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['mrp'] = this.mrp;
    data['basePrice'] = this.basePrice;
    data['yourPrice'] = this.yourPrice;
    data['itemId'] = this.itemId;
    if (this.attributecategory != null) {
      data['attributecategory'] = this.attributecategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.attributeName != null) {
      data['attributeName'] = this.attributeName!.toJson();
    }
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    data['totalGst'] = this.totalGst;
    return data;
  }
}

class Attributecategory {
  String? label;
  int? value;

  Attributecategory({this.label, this.value});

  Attributecategory.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

class AttributeName {
  Attributecategory? a3;
  Attributecategory? a17;
  Attributecategory? a18;
  Attributecategory? a2;

  AttributeName({this.a3, this.a17, this.a18, this.a2});

  AttributeName.fromJson(Map<String, dynamic> json) {
    a3 = json['3'] != null ? new Attributecategory.fromJson(json['3']) : null;
    a17 = json['17'] != null
        ? new Attributecategory.fromJson(json['17'])
        : null;
    a18 = json['18'] != null
        ? new Attributecategory.fromJson(json['18'])
        : null;
    a2 = json['2'] != null ? new Attributecategory.fromJson(json['2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.a3 != null) {
      data['3'] = this.a3!.toJson();
    }
    if (this.a17 != null) {
      data['17'] = this.a17!.toJson();
    }
    if (this.a18 != null) {
      data['18'] = this.a18!.toJson();
    }
    if (this.a2 != null) {
      data['2'] = this.a2!.toJson();
    }
    return data;
  }
}

class Item {
  int? id;
  String? name;
  String? description;
  bool? isFeatured;
  bool? isTopSelling;
  double? commision;
  int? gst;
  String? units;
  dynamic basePrice;
  int? barCode;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  List<ItemImages>? itemImages;
  List<ItemBrands>? itemBrands;
  List<ItemCategories>? itemCategories;
  List<ItemStageCategories>? itemStageCategories;
  List<ItemAttributeCategories>? itemAttributeCategories;

  Item({
    this.id,
    this.name,
    this.description,
    this.isFeatured,
    this.isTopSelling,
    this.commision,
    this.gst,
    this.units,
    this.basePrice,
    this.barCode,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.itemImages,
    this.itemBrands,
    this.itemCategories,
    this.itemStageCategories,
    this.itemAttributeCategories,
  });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isFeatured = json['isFeatured'];
    isTopSelling = json['isTopSelling'];
    commision:
    json["commision"] == null ? null : (json["commision"] as num).toDouble();
    // commision = json['commision'];
    gst = json['gst'];

    units = json['units'];
    basePrice = json['basePrice'];
    barCode = json['barCode'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    if (json['itemImages'] != null) {
      itemImages = <ItemImages>[];
      json['itemImages'].forEach((v) {
        itemImages!.add(new ItemImages.fromJson(v));
      });
    }
    if (json['itemBrands'] != null) {
      itemBrands = <ItemBrands>[];
      json['itemBrands'].forEach((v) {
        itemBrands!.add(new ItemBrands.fromJson(v));
      });
    }
    if (json['itemCategories'] != null) {
      itemCategories = <ItemCategories>[];
      json['itemCategories'].forEach((v) {
        itemCategories!.add(new ItemCategories.fromJson(v));
      });
    }
    if (json['itemStageCategories'] != null) {
      itemStageCategories = <ItemStageCategories>[];
      json['itemStageCategories'].forEach((v) {
        itemStageCategories!.add(new ItemStageCategories.fromJson(v));
      });
    }
    if (json['itemAttributeCategories'] != null) {
      itemAttributeCategories = <ItemAttributeCategories>[];
      json['itemAttributeCategories'].forEach((v) {
        itemAttributeCategories!.add(new ItemAttributeCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isFeatured'] = this.isFeatured;
    data['isTopSelling'] = this.isTopSelling;
    data['commision'] = this.commision;
    data['gst'] = this.gst;
    data['units'] = this.units;
    data['basePrice'] = this.basePrice;
    data['barCode'] = this.barCode;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    if (this.itemImages != null) {
      data['itemImages'] = this.itemImages!.map((v) => v.toJson()).toList();
    }
    if (this.itemBrands != null) {
      data['itemBrands'] = this.itemBrands!.map((v) => v.toJson()).toList();
    }
    if (this.itemCategories != null) {
      data['itemCategories'] = this.itemCategories!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.itemStageCategories != null) {
      data['itemStageCategories'] = this.itemStageCategories!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.itemAttributeCategories != null) {
      data['itemAttributeCategories'] = this.itemAttributeCategories!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ItemImages {
  int? id;
  String? image;
  String? fileName;

  ItemImages({this.id, this.image, this.fileName});

  ItemImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['Image'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Image'] = this.image;
    data['fileName'] = this.fileName;
    return data;
  }
}

class ItemBrands {
  int? id;
  int? brandId;
  Brands? brands;

  ItemBrands({this.id, this.brandId, this.brands});

  ItemBrands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brandId'];
    brands = json['brands'] != null
        ? new Brands.fromJson(json['brands'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brandId'] = this.brandId;
    if (this.brands != null) {
      data['brands'] = this.brands!.toJson();
    }
    return data;
  }
}

class Brands {
  int? id;
  String? name;

  Brands({this.id, this.name});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ItemCategories {
  int? id;
  int? categoryId;
  Category? category;

  ItemCategories({this.id, this.categoryId, this.category});

  ItemCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryId'] = this.categoryId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  List<SubCategories>? subCategories;

  Category({this.id, this.name, this.subCategories});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['subCategories'] != null) {
      subCategories = <SubCategories>[];
      json['subCategories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subCategories != null) {
      data['subCategories'] = this.subCategories!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class SubCategories {
  int? id;
  String? name;
  String? image;
  String? fileName;
  int? size;
  int? categoryId;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;

  SubCategories({
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

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['Image'];
    fileName = json['fileName'];
    size = json['size'];
    categoryId = json['categoryId'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['Image'] = this.image;
    data['fileName'] = this.fileName;
    data['size'] = this.size;
    data['categoryId'] = this.categoryId;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ItemStageCategories {
  int? id;
  int? stageCategoryId;
  Brands? stageCategory;

  ItemStageCategories({this.id, this.stageCategoryId, this.stageCategory});

  ItemStageCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stageCategoryId = json['stageCategoryId'];
    stageCategory = json['stageCategory'] != null
        ? new Brands.fromJson(json['stageCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stageCategoryId'] = this.stageCategoryId;
    if (this.stageCategory != null) {
      data['stageCategory'] = this.stageCategory!.toJson();
    }
    return data;
  }
}

class ItemAttributeCategories {
  int? id;
  int? attributeCategoryId;
  List<AttributeSubcategory>? attributeSubcategory;
  Brands? attributeCategory;

  ItemAttributeCategories({
    this.id,
    this.attributeCategoryId,
    this.attributeSubcategory,
    this.attributeCategory,
  });

  ItemAttributeCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeCategoryId = json['attributeCategoryId'];
    if (json['attributeSubcategory'] != null) {
      attributeSubcategory = <AttributeSubcategory>[];
      json['attributeSubcategory'].forEach((v) {
        attributeSubcategory!.add(new AttributeSubcategory.fromJson(v));
      });
    }
    attributeCategory = json['attributeCategory'] != null
        ? new Brands.fromJson(json['attributeCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attributeCategoryId'] = this.attributeCategoryId;
    if (this.attributeSubcategory != null) {
      data['attributeSubcategory'] = this.attributeSubcategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.attributeCategory != null) {
      data['attributeCategory'] = this.attributeCategory!.toJson();
    }
    return data;
  }
}

class AttributeSubcategory {
  String? mrp;
  String? label;
  int? value;
  String? basePrice;

  AttributeSubcategory({this.mrp, this.label, this.value, this.basePrice});

  AttributeSubcategory.fromJson(Map<String, dynamic> json) {
    mrp = json['mrp'];
    label = json['label'];
    value = json['value'];
    basePrice = json['basePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mrp'] = this.mrp;
    data['label'] = this.label;
    data['value'] = this.value;
    data['basePrice'] = this.basePrice;
    return data;
  }
}
