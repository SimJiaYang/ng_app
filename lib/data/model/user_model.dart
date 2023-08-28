// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final bool? success;
  final Data? data;
  final String? error;

  UserModel({
    this.success,
    this.data,
    this.error,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  final String? name;
  final String? email;
  final String? address;
  final String? gender;
  final String? contactNumber;
  final String? image;
  final DateTime? birthDate;

  Data({
    this.name,
    this.email,
    this.address,
    this.gender,
    this.contactNumber,
    this.image,
    this.birthDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        email: json["email"],
        address: json["address"],
        gender: json["gender"],
        contactNumber: json["contact_number"],
        image: json["image"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "address": address,
        "gender": gender,
        "contact_number": contactNumber,
        "image": image,
        "birth_date":
            "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
      };
}
