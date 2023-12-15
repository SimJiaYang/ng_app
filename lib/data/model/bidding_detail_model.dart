// To parse this JSON data, do
//
//     final biddingDetailModel = biddingDetailModelFromJson(jsonString);

import 'dart:convert';

BiddingDetailModel biddingDetailModelFromJson(String str) =>
    BiddingDetailModel.fromJson(json.decode(str));

String biddingDetailModelToJson(BiddingDetailModel data) =>
    json.encode(data.toJson());

class BiddingDetailModel {
  bool? success;
  Data? data;
  String? error;

  BiddingDetailModel({
    this.success,
    this.data,
    this.error,
  });

  factory BiddingDetailModel.fromJson(Map<String, dynamic> json) =>
      BiddingDetailModel(
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
  Bid? bid;
  int? userBid;

  Data({
    this.userBid,
    this.bid,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userBid: json["user_bid"],
        bid: json["bid"] == null ? null : Bid.fromJson(json["bid"]),
      );

  Map<String, dynamic> toJson() => {
        "user_bid": userBid,
        "bid": bid?.toJson(),
      };
}

class Bid {
  int? id;
  int? intialAmt;
  int? minAmt;
  String? status;
  dynamic winnerId;
  int? highestAmt;
  DateTime? startTime;
  DateTime? endTime;
  int? plantId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Bid({
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
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
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
      };
}
