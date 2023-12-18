// To parse this JSON data, do
//
//     final biddingModel = biddingModelFromJson(jsonString);

import 'dart:convert';

import 'package:nurserygardenapp/util/app_constants.dart';

BiddingModel biddingModelFromJson(String str) =>
    BiddingModel.fromJson(json.decode(str));

String biddingModelToJson(BiddingModel data) => json.encode(data.toJson());

class BiddingModel {
  bool? success;
  Data? data;
  String? error;

  BiddingModel({
    this.success,
    this.data,
    this.error,
  });

  factory BiddingModel.fromJson(Map<String, dynamic> json) => BiddingModel(
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
  BiddingList? biddingList;

  Data({
    this.biddingList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        biddingList: json["bidding"] == null
            ? null
            : BiddingList.fromJson(json["bidding"]),
      );

  Map<String, dynamic> toJson() => {
        "bidding": biddingList?.toJson(),
      };
}

class BiddingList {
  int? currentPage;
  List<Bidding>? bidding;
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

  BiddingList({
    this.currentPage,
    this.bidding,
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

  factory BiddingList.fromJson(Map<String, dynamic> json) => BiddingList(
        currentPage: json["current_page"],
        bidding: json["data"] == null
            ? []
            : List<Bidding>.from(json["data"]!.map((x) => Bidding.fromJson(x))),
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
        "data": bidding == null
            ? []
            : List<dynamic>.from(bidding!.map((x) => x.toJson())),
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

class Bidding {
  int? id;
  int? intialAmt;
  int? minAmt;
  String? status;
  dynamic winnerId;
  dynamic highestAmt;
  DateTime? startTime;
  DateTime? endTime;
  int? plantId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  dynamic salesAmount;
  int? price;
  String? description;
  int? quantity;
  String? sunlightNeed;
  String? waterNeed;
  String? matureHeight;
  String? origin;
  String? image;
  int? catId;
  int? biddingId;
  String? categoryName;

  Bidding({
    this.id,
    this.intialAmt,
    this.minAmt,
    this.status,
    this.winnerId,
    this.highestAmt,
    this.startTime,
    this.endTime,
    this.plantId,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.salesAmount,
    this.price,
    this.description,
    this.quantity,
    this.sunlightNeed,
    this.waterNeed,
    this.matureHeight,
    this.origin,
    this.image,
    this.catId,
    this.biddingId,
    this.categoryName,
  });

  factory Bidding.fromJson(Map<String, dynamic> json) => Bidding(
        id: json["id"],
        intialAmt: json["intial_amt"],
        minAmt: json["min_amt"],
        status: json["status"],
        winnerId: json["winner_id"],
        highestAmt: json["highest_amt"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        plantId: json["plant_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        name: json["name"],
        salesAmount: json["sales_amount"],
        price: json["price"],
        description: json["description"],
        quantity: json["quantity"],
        sunlightNeed: json["sunlight_need"],
        waterNeed: json["water_need"],
        matureHeight: json["mature_height"],
        origin: json["origin"],
        image: json["image"] == null
            ? null
            : AppConstants.url + '/plant_image/' + json["image"],
        catId: json["cat_id"],
        biddingId: json["bidding_id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "intial_amt": intialAmt,
        "min_amt": minAmt,
        "status": status,
        "winner_id": winnerId,
        "highest_amt": highestAmt,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "plant_id": plantId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "sales_amount": salesAmount,
        "price": price,
        "description": description,
        "quantity": quantity,
        "sunlight_need": sunlightNeed,
        "water_need": waterNeed,
        "mature_height": matureHeight,
        "origin": origin,
        "image": image,
        "cat_id": catId,
        "bidding_id": biddingId,
        "category_name": categoryName,
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
