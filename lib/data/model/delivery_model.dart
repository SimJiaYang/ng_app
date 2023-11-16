// To parse this JSON data, do
//
//     final deliveryModel = deliveryModelFromJson(jsonString);

import 'dart:convert';

DeliveryModel deliveryModelFromJson(String str) =>
    DeliveryModel.fromJson(json.decode(str));

String deliveryModelToJson(DeliveryModel data) => json.encode(data.toJson());

class DeliveryModel {
  bool? success;
  Data? data;
  String? error;

  DeliveryModel({
    this.success,
    this.data,
    this.error,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => DeliveryModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "error": error,
      };
}

class Data {
  int? currentPage;
  List<Delivery>? delivery;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.delivery,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        delivery: json["data"] == null
            ? []
            : List<Delivery>.from(
                json["data"]!.map((x) => Delivery.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": delivery == null
            ? []
            : List<dynamic>.from(delivery!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Delivery {
  int? id;
  String? trackingNumber;
  String? method;
  String? status;
  dynamic details;
  String? prvImg;
  DateTime? expectedDate;
  int? userId;
  int? orderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imageURL;
  DateTime? orderDate;
  String? orderAddress;

  Delivery({
    this.id,
    this.trackingNumber,
    this.method,
    this.status,
    this.details,
    this.prvImg,
    this.expectedDate,
    this.userId,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.imageURL,
    this.orderDate,
    this.orderAddress,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json["id"],
        trackingNumber: json["tracking_number"],
        method: json["method"],
        status: json["status"],
        details: json["details"],
        prvImg: json["prv_img"],
        expectedDate: json["expected_date"] == null
            ? null
            : DateTime.parse(json["expected_date"]),
        userId: json["user_id"],
        orderId: json["order_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        imageURL: jsonDecode(json["image_url"]),
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        orderAddress: json["order_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tracking_number": trackingNumber,
        "method": method,
        "status": status,
        "details": details,
        "prv_img": prvImg,
        "expected_date":
            "${expectedDate!.year.toString().padLeft(4, '0')}-${expectedDate!.month.toString().padLeft(2, '0')}-${expectedDate!.day.toString().padLeft(2, '0')}",
        "user_id": userId,
        "order_id": orderId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "image_url": imageURL,
        "order_date": orderDate?.toIso8601String(),
        "order_address": orderAddress,
      };
}

// enum Method { BBOSS, GDEX, J_T }

// final methodValues =
//     EnumValues({"BBOSS": Method.BBOSS, "GDEX": Method.GDEX, "J&T": Method.J_T});

// enum Status { DELIVERED, SHIP }

// final statusValues =
//     EnumValues({"delivered": Status.DELIVERED, "ship": Status.SHIP});

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
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
