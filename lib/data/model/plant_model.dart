// To parse this JSON data, do
//
//     final plantModel = plantModelFromJson(jsonString);

import 'dart:convert';

PlantModel plantModelFromJson(String str) =>
    PlantModel.fromJson(json.decode(str));

String plantModelToJson(PlantModel data) => json.encode(data.toJson());

class PlantModel {
  final bool? success;
  final Data? data;
  final String? error;

  PlantModel({
    this.success,
    this.data,
    this.error,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) => PlantModel(
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
  final List<Plant>? plant;

  Data({
    this.plant,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        plant: json["plant"] == null
            ? []
            : List<Plant>.from(json["plant"]!.map((x) => Plant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plant": plant == null
            ? []
            : List<dynamic>.from(plant!.map((x) => x.toJson())),
      };
}

class Plant {
  final int? id;
  final String? name;
  final double? price;
  final String? description;
  final int? quantity;
  final String? sunglightNeed;
  final String? waterNeed;
  final String? matureHeight;
  final String? origin;
  final String? status;
  final String? image;
  final int? catId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? categoryName;
  final String? imageURL;

  Plant({
    this.id,
    this.name,
    this.price,
    this.description,
    this.quantity,
    this.sunglightNeed,
    this.waterNeed,
    this.matureHeight,
    this.origin,
    this.status,
    this.image,
    this.catId,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.imageURL,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json["id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        quantity: json["quantity"],
        sunglightNeed: json["sunglight_need"],
        waterNeed: json["water_need"],
        matureHeight: json["mature_height"],
        origin: json["origin"],
        status: json["status"],
        image: json["image"],
        catId: json["cat_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        categoryName: json["category_name"],
        imageURL: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "quantity": quantity,
        "sunglight_need": sunglightNeed,
        "water_need": waterNeed,
        "mature_height": matureHeight,
        "origin": origin,
        "status": status,
        "image": image,
        "cat_id": catId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category_name": categoryName,
        "image_url": imageURL,
      };
}
