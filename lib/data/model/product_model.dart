// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final bool? success;
  final Data? data;
  final String? error;

  ProductModel({
    this.success,
    this.data,
    this.error,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
  final List<Product>? product;

  Data({
    this.product,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        product: json["product"] == null
            ? []
            : List<Product>.from(
                json["product"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product": product == null
            ? []
            : List<dynamic>.from(product!.map((x) => x.toJson())),
      };
}

class Product {
  final int? id;
  final String? name;
  final double? price;
  final String? description;
  final int? quantity;
  final String? status;
  final String? image;
  final int? catId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? categoryName;
  final String? imageURL;

  Product({
    this.id,
    this.name,
    this.price,
    this.description,
    this.quantity,
    this.status,
    this.image,
    this.catId,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.imageURL,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"].toDouble(),
        description: json["description"],
        quantity: json["quantity"],
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
        "status": status,
        "image": image,
        "cat_id": catId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category_name": categoryName,
        "image_url": imageURL,
      };
}
