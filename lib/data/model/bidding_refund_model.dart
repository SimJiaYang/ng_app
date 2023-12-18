// To parse this JSON data, do
//
//     final biddingRefundModel = biddingRefundModelFromJson(jsonString);

import 'dart:convert';

BiddingRefundModel biddingRefundModelFromJson(String str) =>
    BiddingRefundModel.fromJson(json.decode(str));

String biddingRefundModelToJson(BiddingRefundModel data) =>
    json.encode(data.toJson());

class BiddingRefundModel {
  bool? success;
  Data? data;
  String? error;

  BiddingRefundModel({
    this.success,
    this.data,
    this.error,
  });

  factory BiddingRefundModel.fromJson(Map<String, dynamic> json) =>
      BiddingRefundModel(
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
  RefundList? refundList;

  Data({
    this.refundList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        refundList: json["refund_list"] == null
            ? null
            : RefundList.fromJson(json["refund_list"]),
      );

  Map<String, dynamic> toJson() => {
        "refund_list": refundList?.toJson(),
      };
}

class RefundList {
  int? currentPage;
  List<Refund>? refund;
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

  RefundList({
    this.currentPage,
    this.refund,
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

  factory RefundList.fromJson(Map<String, dynamic> json) => RefundList(
        currentPage: json["current_page"],
        refund: json["data"] == null
            ? []
            : List<Refund>.from(json["data"]!.map((x) => Refund.fromJson(x))),
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
        "data": refund == null
            ? []
            : List<dynamic>.from(refund!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Refund {
  int? id;
  int? biddingId;
  int? userId;
  int? amount;
  String? refundStatus;
  String? paymentWay;
  DateTime? createdAt;
  DateTime? updatedAt;

  Refund({
    this.id,
    this.biddingId,
    this.userId,
    this.amount,
    this.refundStatus,
    this.paymentWay,
    this.createdAt,
    this.updatedAt,
  });

  factory Refund.fromJson(Map<String, dynamic> json) => Refund(
        id: json["id"],
        biddingId: json["bidding_id"],
        userId: json["user_id"],
        amount: json["amount"],
        refundStatus: json["refund_status"],
        paymentWay: json["payment_way"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bidding_id": biddingId,
        "user_id": userId,
        "amount": amount,
        "refund_status": refundStatus,
        "payment_way": paymentWay,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

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
