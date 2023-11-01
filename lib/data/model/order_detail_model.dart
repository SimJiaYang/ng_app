// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';

OrderDetailModel orderDetailModelFromJson(String str) =>
    OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) =>
    json.encode(data.toJson());

class OrderDetailModel {
  bool? success;
  Data? data;
  String? error;

  OrderDetailModel({
    this.success,
    this.data,
    this.error,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
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
  String? order_address;
  List<Plant>? plant;
  List<Product>? product;
  List<OrderItem>? orderItem;

  Data({
    this.order_address,
    this.plant,
    this.product,
    this.orderItem,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        order_address: json["order_address"],
        plant: json["plant"] == null
            ? []
            : List<Plant>.from(json["plant"]!.map((x) => Plant.fromJson(x))),
        product: json["product"] == null
            ? []
            : List<Product>.from(
                json["product"]!.map((x) => Product.fromJson(x))),
        orderItem: json["order_item"] == null
            ? []
            : List<OrderItem>.from(
                json["order_item"]!.map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plant": plant == null
            ? []
            : List<dynamic>.from(plant!.map((x) => x.toJson())),
        "product": product == null
            ? []
            : List<dynamic>.from(product!.map((x) => x.toJson())),
        "order_item": orderItem == null
            ? []
            : List<dynamic>.from(orderItem!.map((x) => x.toJson())),
      };
}

class OrderItem {
  int? id;
  int? quantity;
  double? price;
  double? amount;
  int? orderId;
  dynamic cartId;
  int? productId;
  int? plantId;
  dynamic biddingId;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderItem({
    this.id,
    this.quantity,
    this.price,
    this.amount,
    this.orderId,
    this.cartId,
    this.productId,
    this.plantId,
    this.biddingId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        amount: json["amount"]?.toDouble(),
        orderId: json["order_id"],
        cartId: json["cart_id"],
        productId: json["product_id"],
        plantId: json["plant_id"],
        biddingId: json["bidding_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "price": price,
        "amount": amount,
        "order_id": orderId,
        "cart_id": cartId,
        "product_id": productId,
        "plant_id": plantId,
        "bidding_id": biddingId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
