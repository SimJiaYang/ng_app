// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final bool? success;
  final UserData? data;
  final String? error;

  UserModel({
    this.success,
    this.data,
    this.error,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "error": error,
      };
}

class UserData {
  String? name;
  String? address;
  String? email;
  String? gender;
  String? image;
  String? contactNumber;
  String? image_url;
  DateTime? birthDate;

  UserData({
    this.name,
    this.email,
    this.address,
    this.gender,
    this.image,
    this.contactNumber,
    this.image_url,
    this.birthDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        email: json["email"],
        address: json["address"],
        gender: json["gender"],
        image: json["image"],
        contactNumber: json["contact_number"],
        image_url: json["image_url"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "address": address,
        "gender": gender,
        "image_name": image,
        "contact_number": contactNumber,
        "image_url": image_url,
        "birth_date": birthDate == null
            ? null
            : "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
      };
}
