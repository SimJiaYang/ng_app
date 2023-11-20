// To parse this JSON data, do
//
//     final deliveryReceiptModel = deliveryReceiptModelFromJson(jsonString);

import 'dart:convert';

import 'package:nurserygardenapp/data/model/delivery_model.dart';
import 'package:nurserygardenapp/data/model/order_model.dart';
import 'package:nurserygardenapp/data/model/user_model.dart';

DeliveryReceiptModel deliveryReceiptModelFromJson(String str) =>
    DeliveryReceiptModel.fromJson(json.decode(str));

String deliveryReceiptModelToJson(DeliveryReceiptModel data) =>
    json.encode(data.toJson());

class DeliveryReceiptModel {
  bool? success;
  Data? data;
  String? error;

  DeliveryReceiptModel({
    this.success,
    this.data,
    this.error,
  });

  factory DeliveryReceiptModel.fromJson(Map<String, dynamic> json) =>
      DeliveryReceiptModel(
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
  UserData? user;
  List<DeliveryOrderDetail>? deliveryOrderDetail;
  Order? order;
  Sender? sender;
  Delivery? delivery;

  Data({
    this.user,
    this.deliveryOrderDetail,
    this.order,
    this.sender,
    this.delivery,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : UserData.fromJson(json["user"]),
        deliveryOrderDetail: json["delivery_order_detail"] == null
            ? []
            : List<DeliveryOrderDetail>.from(json["delivery_order_detail"]!
                .map((x) => DeliveryOrderDetail.fromJson(x))),
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
        delivery: json["delivery"] == null
            ? null
            : Delivery.fromJson(json["delivery"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "delivery_order_detail": deliveryOrderDetail == null
            ? []
            : List<dynamic>.from(deliveryOrderDetail!.map((x) => x.toJson())),
        "order": order?.toJson(),
        "sender": sender?.toJson(),
        "delivery": delivery?.toJson(),
      };
}

class DeliveryOrderDetail {
  int? id;
  int? quantity;
  double? price;
  double? amount;
  int? orderId;
  String? remark;
  dynamic productId;
  int? plantId;
  int? deliveryId;
  dynamic biddingId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? plantName;
  double? plantPrice;
  String? plantImage;
  dynamic productName;
  dynamic productPrice;
  dynamic productImage;
  String? imageUrl;

  DeliveryOrderDetail({
    this.id,
    this.quantity,
    this.price,
    this.amount,
    this.orderId,
    this.remark,
    this.productId,
    this.plantId,
    this.deliveryId,
    this.biddingId,
    this.createdAt,
    this.updatedAt,
    this.plantName,
    this.plantPrice,
    this.plantImage,
    this.productName,
    this.productPrice,
    this.productImage,
    this.imageUrl,
  });

  factory DeliveryOrderDetail.fromJson(Map<String, dynamic> json) =>
      DeliveryOrderDetail(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        amount: json["amount"]?.toDouble(),
        orderId: json["order_id"],
        remark: json["remark"],
        productId: json["product_id"],
        plantId: json["plant_id"],
        deliveryId: json["delivery_id"],
        biddingId: json["bidding_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        plantName: json["plant_name"],
        plantPrice: json["plant_price"]?.toDouble(),
        plantImage: json["plant_image"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productImage: json["product_image"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "price": price,
        "amount": amount,
        "order_id": orderId,
        "remark": remark,
        "product_id": productId,
        "plant_id": plantId,
        "delivery_id": deliveryId,
        "bidding_id": biddingId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "plant_name": plantName,
        "plant_price": plantPrice,
        "plant_image": plantImage,
        "product_name": productName,
        "product_price": productPrice,
        "product_image": productImage,
        "image_url": imageUrl,
      };
}

class Sender {
  String? sender;
  String? address;

  Sender({
    this.sender,
    this.address,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        sender: json["Sender"],
        address: json["Address"],
      );

  Map<String, dynamic> toJson() => {
        "Sender": sender,
        "Address": address,
      };
}
