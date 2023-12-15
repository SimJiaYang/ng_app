// To parse this JSON data, do
//
//     final paymentBiddingModel = paymentBiddingModelFromJson(jsonString);

import 'dart:convert';

PaymentBiddingModel paymentBiddingModelFromJson(String str) =>
    PaymentBiddingModel.fromJson(json.decode(str));

String paymentBiddingModelToJson(PaymentBiddingModel data) =>
    json.encode(data.toJson());

class PaymentBiddingModel {
  bool? success;
  Data? data;
  String? error;

  PaymentBiddingModel({
    this.success,
    this.data,
    this.error,
  });

  factory PaymentBiddingModel.fromJson(Map<String, dynamic> json) =>
      PaymentBiddingModel(
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
  Payment? payment;

  Data({
    this.payment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      );

  Map<String, dynamic> toJson() => {
        "payment": payment?.toJson(),
      };
}

class Payment {
  String? clientSecret;
  int? amount;

  Payment({
    this.clientSecret,
    this.amount,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        clientSecret: json["Client_Secret"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "Client_Secret": clientSecret,
        "amount": amount,
      };
}
