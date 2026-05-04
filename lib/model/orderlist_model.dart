class OrderListModel {
  bool? status;
  String? message;
  List<Data>? data;

  OrderListModel({this.status, this.message, this.data});

  OrderListModel.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  int? userId;
  int? userAddressId;
  dynamic totalPrice;
  dynamic totalcalculatorPrice;
  dynamic grandTotal;
  dynamic discount;
  dynamic projectId;
  dynamic paidAmount;
  dynamic pendingAmount;
  String? orderStatus;
  String? deliveryStatus;
  String? paymentStatus;
  String? createdAt;
  Users? users;
  Count? cCount;

  Data({
    this.id,
    this.orderId,
    this.userId,
    this.userAddressId,
    this.totalPrice,
    this.totalcalculatorPrice,
    this.grandTotal,
    this.discount,
    this.projectId,
    this.paidAmount,
    this.pendingAmount,
    this.orderStatus,
    this.deliveryStatus,
    this.paymentStatus,
    this.createdAt,
    this.users,
    this.cCount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    userId = json['userId'];
    userAddressId = json['userAddressId'];
    totalPrice = json['totalPrice'];
    totalcalculatorPrice = json['totalcalculatorPrice'];
    grandTotal = json['grandTotal'];
    discount = json['discount'];
    projectId = json['projectId'];
    paidAmount = json['paidAmount'];
    pendingAmount = json['pendingAmount'];
    orderStatus = json['orderStatus'];
    deliveryStatus = json['deliveryStatus'];
    paymentStatus = json['paymentStatus'];
    createdAt = json['createdAt'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    cCount = json['_count'] != null ? new Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['orderId'] = orderId;
    data['userId'] = userId;
    data['userAddressId'] = userAddressId;
    data['totalPrice'] = totalPrice;
    data['totalcalculatorPrice'] = totalcalculatorPrice;
    data['grandTotal'] = grandTotal;
    data['discount'] = discount;
    data['projectId'] = projectId;
    data['paidAmount'] = paidAmount;
    data['pendingAmount'] = pendingAmount;
    data['orderStatus'] = orderStatus;
    data['deliveryStatus'] = deliveryStatus;
    data['paymentStatus'] = paymentStatus;
    data['createdAt'] = createdAt;
    if (users != null) {
      data['users'] = users!.toJson();
    }
    if (cCount != null) {
      data['_count'] = cCount!.toJson();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;

  Users({this.id, this.name});

  Users.fromJson(Map<String, dynamic> json) {
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

class Count {
  int? orderItems;

  Count({this.orderItems});

  Count.fromJson(Map<String, dynamic> json) {
    orderItems = json['orderItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderItems'] = orderItems;
    return data;
  }
}
