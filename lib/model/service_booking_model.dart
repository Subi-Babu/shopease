class ServiceBookingModel {
  bool? status;
  String? message;
  List<Data>? data;

  ServiceBookingModel({this.status, this.message, this.data});

  ServiceBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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
  String? date;
  String? message;
  String? fileName;
  String? file;
  int? size;
  dynamic grandTotal;
  dynamic invoiceAmount;
  dynamic discount;
  dynamic paidAmount;
  dynamic pendingAmount;
  dynamic gst;
  dynamic cGST;
  dynamic sGST;
  dynamic iGST;
  dynamic commision;
  dynamic commisionTax;
  String? serviceManURL;
  dynamic serviceHubDistance;
  dynamic serviceManDistance;
  String? paymentStatus;
  String? status;
  String? serviceManstatus;
  String? isMaterialPurchase;
  int? orderId;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;
  int? projectId;
  Projects? projects;
  Service? service;
  Users? users;
  UserAddress? userAddress;
  Users? serviceHub;
  Users? serviceMan;
  Order? order;
  List<ServiceBookingTransactions>? serviceBookingTransactions;
  List<ServiceCarts>? serviceCarts;
  List<ServiceInspectionReports>? serviceInspectionReports;

  Data({
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
    this.cGST,
    this.sGST,
    this.iGST,
    this.commision,
    this.commisionTax,
    this.serviceManURL,
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceBookingId = json['serviceBookingId'];
    userId = json['userId'];
    serviceId = json['serviceId'];
    serviceHubId = json['serviceHubId'];
    serviceManId = json['serviceManId'];
    userAddressId = json['userAddressId'];
    name = json['name'];
    code = json['code'];
    phoneNumber = json['phoneNumber'];
    date = json['date'];
    message = json['message'];
    fileName = json['fileName'];
    file = json['file'];
    size = json['size'];
    grandTotal = json['grandTotal'];
    invoiceAmount = json['invoiceAmount'];
    discount = json['discount'];
    paidAmount = json['paidAmount'];
    pendingAmount = json['pendingAmount'];
    gst = json['gst'];
    cGST = json['CGST'];
    sGST = json['SGST'];
    iGST = json['IGST'];
    commision = json['commision'];
    commisionTax = json['commisionTax'];
    serviceManURL = json['serviceManURL'];
    serviceHubDistance = json['serviceHubDistance'];
    serviceManDistance = json['serviceManDistance'];
    paymentStatus = json['paymentStatus'];
    status = json['status'];
    serviceManstatus = json['serviceManstatus'];
    isMaterialPurchase = json['isMaterialPurchase'];
    orderId = json['orderId'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    projectId = json['projectId'];
    projects = json['projects'] != null
        ? new Projects.fromJson(json['projects'])
        : null;
    service = json['service'] != null
        ? new Service.fromJson(json['service'])
        : null;
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    userAddress = json['userAddress'] != null
        ? new UserAddress.fromJson(json['userAddress'])
        : null;
    serviceHub = json['serviceHub'] != null
        ? new Users.fromJson(json['serviceHub'])
        : null;
    serviceMan = json['serviceMan'] != null
        ? new Users.fromJson(json['serviceMan'])
        : null;
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    if (json['serviceBookingTransactions'] != null) {
      serviceBookingTransactions = <ServiceBookingTransactions>[];
      json['serviceBookingTransactions'].forEach((v) {
        serviceBookingTransactions!.add(
          new ServiceBookingTransactions.fromJson(v),
        );
      });
    }
    if (json['serviceCarts'] != null) {
      serviceCarts = <ServiceCarts>[];
      json['serviceCarts'].forEach((v) {
        serviceCarts!.add(new ServiceCarts.fromJson(v));
      });
    }
    if (json['serviceInspectionReports'] != null) {
      serviceInspectionReports = <ServiceInspectionReports>[];
      json['serviceInspectionReports'].forEach((v) {
        serviceInspectionReports!.add(new ServiceInspectionReports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['serviceBookingId'] = serviceBookingId;
    data['userId'] = userId;
    data['serviceId'] = serviceId;
    data['serviceHubId'] = serviceHubId;
    data['serviceManId'] = serviceManId;
    data['userAddressId'] = userAddressId;
    data['name'] = name;
    data['code'] = code;
    data['phoneNumber'] = phoneNumber;
    data['date'] = date;
    data['message'] = message;
    data['fileName'] = fileName;
    data['file'] = file;
    data['size'] = size;
    data['grandTotal'] = grandTotal;
    data['invoiceAmount'] = invoiceAmount;
    data['discount'] = discount;
    data['paidAmount'] = paidAmount;
    data['pendingAmount'] = pendingAmount;
    data['gst'] = gst;
    data['CGST'] = cGST;
    data['SGST'] = sGST;
    data['IGST'] = iGST;
    data['commision'] = commision;
    data['commisionTax'] = commisionTax;
    data['serviceManURL'] = serviceManURL;
    data['serviceHubDistance'] = serviceHubDistance;
    data['serviceManDistance'] = serviceManDistance;
    data['paymentStatus'] = paymentStatus;
    data['status'] = status;
    data['serviceManstatus'] = serviceManstatus;
    data['isMaterialPurchase'] = isMaterialPurchase;
    data['orderId'] = orderId;
    data['isActive'] = isActive;
    data['isDelete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['projectId'] = projectId;
    if (projects != null) {
      data['projects'] = projects!.toJson();
    }
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (users != null) {
      data['users'] = users!.toJson();
    }
    if (userAddress != null) {
      data['userAddress'] = userAddress!.toJson();
    }
    if (serviceHub != null) {
      data['serviceHub'] = serviceHub!.toJson();
    }
    if (serviceMan != null) {
      data['serviceMan'] = serviceMan!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (serviceBookingTransactions != null) {
      data['serviceBookingTransactions'] = serviceBookingTransactions!
          .map((v) => v.toJson())
          .toList();
    }
    if (serviceCarts != null) {
      data['serviceCarts'] = serviceCarts!.map((v) => v.toJson()).toList();
    }
    if (serviceInspectionReports != null) {
      data['serviceInspectionReports'] = serviceInspectionReports!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class Projects {
  int? id;
  String? name;

  Projects({this.id, this.name});

  Projects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Service {
  int? id;
  String? name;
  String? image;

  Service({this.id, this.name, this.image});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['Image'] = image;
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? code;
  String? phoneNumber;

  Users({this.id, this.name, this.code, this.phoneNumber});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
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
  String? createdAt;
  String? updatedAt;

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

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    address = json['address'];
    addressTitle = json['addressTitle'];
    pinCode = json['pinCode'];
    location = json['location'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    code = json['code'];
    countryId = json['countryId'];
    zoneId = json['zoneId'];
    clusterId = json['clusterId'];
    stateId = json['stateId'];
    districtId = json['districtId'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    isDefault = json['isDefault'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['address'] = address;
    data['addressTitle'] = addressTitle;
    data['pinCode'] = pinCode;
    data['location'] = location;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['code'] = code;
    data['countryId'] = countryId;
    data['zoneId'] = zoneId;
    data['clusterId'] = clusterId;
    data['stateId'] = stateId;
    data['districtId'] = districtId;
    data['isActive'] = isActive;
    data['isDelete'] = isDelete;
    data['isDefault'] = isDefault;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Order {
  int? id;
  int? userId;
  String? orderId;
  int? userAddressId;
  dynamic totalPrice;
  dynamic totalcalculatorPrice;
  dynamic discount;
  dynamic grandTotal;
  dynamic paidAmount;
  dynamic pendingAmount;
  dynamic totalDeliveryCharge;
  int? projectId;
  bool? isDelete;
  String? orderStatus;
  String? deliveryStatus;
  String? paymentMethod;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;

  Order({
    this.id,
    this.userId,
    this.orderId,
    this.userAddressId,
    this.totalPrice,
    this.totalcalculatorPrice,
    this.discount,
    this.grandTotal,
    this.paidAmount,
    this.pendingAmount,
    this.totalDeliveryCharge,
    this.projectId,
    this.isDelete,
    this.orderStatus,
    this.deliveryStatus,
    this.paymentMethod,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    orderId = json['orderId'];
    userAddressId = json['userAddressId'];
    totalPrice = json['totalPrice'];
    totalcalculatorPrice = json['totalcalculatorPrice'];
    discount = json['discount'];
    grandTotal = json['grandTotal'];
    paidAmount = json['paidAmount'];
    pendingAmount = json['pendingAmount'];
    totalDeliveryCharge = json['totalDeliveryCharge'];
    projectId = json['projectId'];
    isDelete = json['isDelete'];
    orderStatus = json['orderStatus'];
    deliveryStatus = json['deliveryStatus'];
    paymentMethod = json['paymentMethod'];
    paymentStatus = json['paymentStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['orderId'] = orderId;
    data['userAddressId'] = userAddressId;
    data['totalPrice'] = totalPrice;
    data['totalcalculatorPrice'] = totalcalculatorPrice;
    data['discount'] = discount;
    data['grandTotal'] = grandTotal;
    data['paidAmount'] = paidAmount;
    data['pendingAmount'] = pendingAmount;
    data['totalDeliveryCharge'] = totalDeliveryCharge;
    data['projectId'] = projectId;
    data['isDelete'] = isDelete;
    data['orderStatus'] = orderStatus;
    data['deliveryStatus'] = deliveryStatus;
    data['paymentMethod'] = paymentMethod;
    data['paymentStatus'] = paymentStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ServiceBookingTransactions {
  int? id;
  int? serviceBookingId;
  String? date;
  String? transactionId;
  dynamic amount;
  String? paymentMode;
  String? image;
  dynamic fileName;
  dynamic size;
  String? createdAt;
  String? updatedAt;

  ServiceBookingTransactions({
    this.id,
    this.serviceBookingId,
    this.date,
    this.transactionId,
    this.amount,
    this.paymentMode,
    this.image,
    this.fileName,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  ServiceBookingTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceBookingId = json['serviceBookingId'];
    date = json['date'];
    transactionId = json['transactionId'];
    amount = json['amount'];
    paymentMode = json['paymentMode'];
    image = json['Image'];
    fileName = json['fileName'];
    size = json['size'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['serviceBookingId'] = serviceBookingId;
    data['date'] = date;
    data['transactionId'] = transactionId;
    data['amount'] = amount;
    data['paymentMode'] = paymentMode;
    data['Image'] = image;
    data['fileName'] = fileName;
    data['size'] = size;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ServiceCarts {
  int? id;
  int? serviceHubId;
  int? serviceBookingId;
  int? storeId;
  int? itemId;
  int? userId;
  dynamic mrp;
  dynamic calculatorPrice;
  int? qty;
  dynamic cGST;
  dynamic sGST;
  dynamic iGST;
  dynamic commision;
  int? categoryId;
  int? projectId;
  List<Attributecategory>? attributecategory;
  AttributeName? attributeName;
  int? orderId;
  bool? isOrder;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;

  ServiceCarts({
    this.id,
    this.serviceHubId,
    this.serviceBookingId,
    this.storeId,
    this.itemId,
    this.userId,
    this.mrp,
    this.calculatorPrice,
    this.qty,
    this.cGST,
    this.sGST,
    this.iGST,
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

  ServiceCarts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceHubId = json['serviceHubId'];
    serviceBookingId = json['serviceBookingId'];
    storeId = json['storeId'];
    itemId = json['itemId'];
    userId = json['userId'];
    mrp = json['mrp'];
    calculatorPrice = json['calculatorPrice'];
    qty = json['qty'];
    cGST = json['CGST'];
    sGST = json['SGST'];
    iGST = json['IGST'];
    commision = json['commision'];
    categoryId = json['categoryId'];
    projectId = json['projectId'];
    if (json['attributecategory'] != null) {
      attributecategory = <Attributecategory>[];
      json['attributecategory'].forEach((v) {
        attributecategory!.add(new Attributecategory.fromJson(v));
      });
    }
    attributeName = json['attributeName'] != null
        ? new AttributeName.fromJson(json['attributeName'])
        : null;
    orderId = json['orderId'];
    isOrder = json['isOrder'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['serviceHubId'] = serviceHubId;
    data['serviceBookingId'] = serviceBookingId;
    data['storeId'] = storeId;
    data['itemId'] = itemId;
    data['userId'] = userId;
    data['mrp'] = mrp;
    data['calculatorPrice'] = calculatorPrice;
    data['qty'] = qty;
    data['CGST'] = cGST;
    data['SGST'] = sGST;
    data['IGST'] = iGST;
    data['commision'] = commision;
    data['categoryId'] = categoryId;
    data['projectId'] = projectId;
    if (attributecategory != null) {
      data['attributecategory'] = attributecategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (attributeName != null) {
      data['attributeName'] = attributeName!.toJson();
    }
    data['orderId'] = orderId;
    data['isOrder'] = isOrder;
    data['isDelete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class AttributeName {
  Attributecategory? a2;
  Attributecategory? a17;
  Attributecategory? a18;
  Attributecategory? a14;

  AttributeName({this.a2, this.a17, this.a18, this.a14});

  AttributeName.fromJson(Map<String, dynamic> json) {
    a2 = json['2'] != null ? new Attributecategory.fromJson(json['2']) : null;
    a17 = json['17'] != null
        ? new Attributecategory.fromJson(json['17'])
        : null;
    a18 = json['18'] != null
        ? new Attributecategory.fromJson(json['18'])
        : null;
    a14 = json['14'] != null
        ? new Attributecategory.fromJson(json['14'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (a2 != null) {
      data['2'] = a2!.toJson();
    }
    if (a17 != null) {
      data['17'] = a17!.toJson();
    }
    if (a18 != null) {
      data['18'] = a18!.toJson();
    }
    if (a14 != null) {
      data['14'] = a14!.toJson();
    }
    return data;
  }
}

class ServiceInspectionReports {
  int? id;
  int? serviceBookingId;
  int? serviceManId;
  String? toolsRequired;
  String? materialsRequired;
  String? workTobeDone;
  dynamic serviceChange;
  String? createdAt;
  String? updatedAt;

  ServiceInspectionReports({
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

  ServiceInspectionReports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceBookingId = json['serviceBookingId'];
    serviceManId = json['serviceManId'];
    toolsRequired = json['toolsRequired'];
    materialsRequired = json['materialsRequired'];
    workTobeDone = json['workTobeDone'];
    serviceChange = json['serviceChange'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['serviceBookingId'] = serviceBookingId;
    data['serviceManId'] = serviceManId;
    data['toolsRequired'] = toolsRequired;
    data['materialsRequired'] = materialsRequired;
    data['workTobeDone'] = workTobeDone;
    data['serviceChange'] = serviceChange;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
