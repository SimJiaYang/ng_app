// To parse this JSON data, do
//
//     final deliveryDetailModel = deliveryDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:nurserygardenapp/data/model/delivery_model.dart';

DeliveryDetailModel deliveryDetailModelFromJson(String str) =>
    DeliveryDetailModel.fromJson(json.decode(str));

String deliveryDetailModelToJson(DeliveryDetailModel data) =>
    json.encode(data.toJson());

class DeliveryDetailModel {
  bool? success;
  Delivery? delivery;
  String? error;

  DeliveryDetailModel({
    this.success,
    this.delivery,
    this.error,
  });

  factory DeliveryDetailModel.fromJson(Map<String, dynamic> json) =>
      DeliveryDetailModel(
        success: json["success"],
        delivery: json["data"] == null ? null : Delivery.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": delivery == null ? null : delivery!.toJson(),
        "error": error,
      };
}
