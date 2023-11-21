// To parse this JSON data, do
//
//     final orderReceiptModel = orderReceiptModelFromJson(jsonString);

import 'dart:convert';

import 'package:nurserygardenapp/data/model/delivery_receipt_model.dart';
import 'package:nurserygardenapp/data/model/order_model.dart';

OrderReceiptModel orderReceiptModelFromJson(String str) =>
    OrderReceiptModel.fromJson(json.decode(str));

String orderReceiptModelToJson(OrderReceiptModel data) =>
    json.encode(data.toJson());

class OrderReceiptModel {
  bool? success;
  Data? data;
  String? error;

  OrderReceiptModel({
    this.success,
    this.data,
    this.error,
  });

  factory OrderReceiptModel.fromJson(Map<String, dynamic> json) =>
      OrderReceiptModel(
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
  Order? order;
  List<DeliveryOrderDetail>? orderItem;
  Payment? payment;

  Data({
    this.order,
    this.orderItem,
    this.payment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
        orderItem: json["order_item"] == null
            ? []
            : List<DeliveryOrderDetail>.from(json["order_item"]!
                .map((x) => DeliveryOrderDetail.fromJson(x))),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      );

  Map<String, dynamic> toJson() => {
        "order": order?.toJson(),
        "order_item": orderItem == null
            ? []
            : List<dynamic>.from(orderItem!.map((x) => x.toJson())),
        "payment": payment?.toJson(),
      };
}

class Payment {
  int? id;
  String? method;
  String? status;
  DateTime? updatedAt;
  double? amount;
  DateTime? date;

  Payment({
    this.id,
    this.method,
    this.status,
    this.updatedAt,
    this.amount,
    this.date,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        method: json["method"],
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        amount: json["amount"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method": method,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "amount": amount,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
