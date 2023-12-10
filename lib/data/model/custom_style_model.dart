// To parse this JSON data, do
//
//     final customStyleModel = customStyleModelFromJson(jsonString);

import 'dart:convert';

CustomStyleModel customStyleModelFromJson(String str) =>
    CustomStyleModel.fromJson(json.decode(str));

String customStyleModelToJson(CustomStyleModel data) =>
    json.encode(data.toJson());

class CustomStyleModel {
  bool? success;
  Data? data;
  String? error;

  CustomStyleModel({
    this.success,
    this.data,
    this.error,
  });

  factory CustomStyleModel.fromJson(Map<String, dynamic> json) =>
      CustomStyleModel(
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
  List<Custom>? custom;

  Data({
    this.custom,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        custom: json["custom"] == null
            ? []
            : List<Custom>.from(json["custom"]!.map((x) => Custom.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "custom": custom == null
            ? []
            : List<dynamic>.from(custom!.map((x) => x.toJson())),
      };
}

class Custom {
  int? id;
  String? name;
  String? image;
  String? video;
  String? status;
  dynamic createdAt;
  dynamic updatedAt;
  String? imageUrl;
  String? videoUrl;

  Custom({
    this.id,
    this.name,
    this.image,
    this.video,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.videoUrl,
  });

  factory Custom.fromJson(Map<String, dynamic> json) => Custom(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        video: json["video"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        imageUrl:
            json["image_url"] == null ? null : jsonDecode(json["image_url"]),
        videoUrl:
            json["video_url"] == null ? null : jsonDecode(json["video_url"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "video": video,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_url": imageUrl,
        "video_url": videoUrl,
      };
}
