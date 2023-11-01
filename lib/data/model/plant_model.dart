// To parse this JSON data, do
//
//     final plantModel = plantModelFromJson(jsonString);

import 'dart:convert';

PlantModel plantModelFromJson(String str) =>
    PlantModel.fromJson(json.decode(str));

String plantModelToJson(PlantModel data) => json.encode(data.toJson());

class PlantModel {
  bool? success;
  Data? data;
  String? error;

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
  PlantList? plantList;

  Data({
    this.plantList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        plantList:
            json["plant"] == null ? null : PlantList.fromJson(json["plant"]),
      );

  Map<String, dynamic> toJson() => {
        "plant": plantList?.toJson(),
      };
}

class PlantList {
  int? currentPage;
  List<Plant>? plant;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  PlantList({
    this.currentPage,
    this.plant,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PlantList.fromJson(Map<String, dynamic> json) => PlantList(
        currentPage: json["current_page"],
        plant: json["data"] == null
            ? []
            : List<Plant>.from(json["data"]!.map((x) => Plant.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": plant == null
            ? []
            : List<dynamic>.from(plant!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Plant {
  int? id;
  String? name;
  double? price;
  String? description;
  int? quantity;
  String? sunlightNeed;
  String? waterNeed;
  String? matureHeight;
  String? origin;
  String? status;
  String? image;
  int? catId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? categoryName;
  String? imageURL;

  Plant({
    this.id,
    this.name,
    this.price,
    this.description,
    this.quantity,
    this.sunlightNeed,
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
        sunlightNeed: json["sunlight_need"],
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
        imageURL: jsonDecode(json["image_url"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "quantity": quantity,
        "sunlight_need": sunlightNeed,
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

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
