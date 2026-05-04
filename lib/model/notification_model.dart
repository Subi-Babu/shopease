// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  List<Notification>? notifications;
  int? unreadCount;
  int? totalPages;
  int? currentPage;
  int? perPage;

  NotificationModel({
    this.notifications,
    this.unreadCount,
    this.totalPages,
    this.currentPage,
    this.perPage,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notifications: json["notifications"] == null
            ? []
            : List<Notification>.from(
                json["notifications"]!.map((x) => Notification.fromJson(x)),
              ),
        unreadCount: json["unreadCount"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        perPage: json["perPage"],
      );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null
        ? []
        : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "unreadCount": unreadCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "perPage": perPage,
  };
}

class Notification {
  int? id;
  String? title;
  String? message;
  Data? data;
  bool? isRead;
  DateTime? createdAt;
  int? userId;
  int? projectId;
  dynamic orderId;
  dynamic serviceBookingId;
  dynamic quatationId;
  dynamic estimationId;

  Notification({
    this.id,
    this.title,
    this.message,
    this.data,
    this.isRead,
    this.createdAt,
    this.userId,
    this.projectId,
    this.orderId,
    this.serviceBookingId,
    this.quatationId,
    this.estimationId,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    isRead: json["isRead"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    userId: json["userId"],
    projectId: json["projectId"],
    orderId: json["orderId"],
    serviceBookingId: json["serviceBookingId"],
    quatationId: json["quatationId"],
    estimationId: json["estimationId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": titleValues.reverse[title],
    "message": messageValues.reverse[message],
    "data": data?.toJson(),
    "isRead": isRead,
    "createdAt": createdAt?.toIso8601String(),
    "userId": userId,
    "projectId": projectId,
    "orderId": orderId,
    "serviceBookingId": serviceBookingId,
    "quatationId": quatationId,
    "estimationId": estimationId,
  };
}

class Data {
  int? id;
  String? role;
  String? page;

  Data({this.id, this.role, this.page});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(id: json["id"], role: json["role"], page: json["page"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": roleValues.reverse[role],
    "page": pageValues.reverse[page],
  };
}

enum Page { PROJECTDETAILS }

final pageValues = EnumValues({"projectdetails": Page.PROJECTDETAILS});

enum Role { USERS }

final roleValues = EnumValues({"users": Role.USERS});

enum Message { PROJECT_ID_YPJ4_BB_EXPENSE_ADDED_BY_MAMMUTTY }

final messageValues = EnumValues({
  "ProjectId - YPJ4BB Expense Added by Mammutty":
      Message.PROJECT_ID_YPJ4_BB_EXPENSE_ADDED_BY_MAMMUTTY,
});

enum Title { EXPENSE_ADDED }

final titleValues = EnumValues({"Expense Added": Title.EXPENSE_ADDED});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
