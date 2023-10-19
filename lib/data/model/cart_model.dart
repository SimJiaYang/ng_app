// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  bool? success;
  Data? data;
  String? error;

  CartModel({
    this.success,
    this.data,
    this.error,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
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
  List<Plant>? plant;
  List<Product>? product;
  CartList? cartList;

  Data({
    this.plant,
    this.product,
    this.cartList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        plant: json["plant"] == null
            ? []
            : List<Plant>.from(json["plant"]!.map((x) => Plant.fromJson(x))),
        product: json["product"] == null
            ? []
            : List<Product>.from(
                json["product"]!.map((x) => Product.fromJson(x))),
        cartList: json["cart"] == null ? null : CartList.fromJson(json["cart"]),
      );

  Map<String, dynamic> toJson() => {
        "plant": plant == null
            ? []
            : List<dynamic>.from(plant!.map((x) => x.toJson())),
        "product": product == null
            ? []
            : List<dynamic>.from(product!.map((x) => x.toJson())),
        "cart": cartList?.toJson(),
      };
}

class CartList {
  int? currentPage;
  List<Cart>? cart;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  CartList({
    this.currentPage,
    this.cart,
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

  factory CartList.fromJson(Map<String, dynamic> json) => CartList(
        currentPage: json["current_page"],
        cart: json["data"] == null
            ? []
            : List<Cart>.from(json["data"]!.map((x) => Cart.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": cart == null
            ? []
            : List<dynamic>.from(cart!.map((x) => x.toJson())),
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

class Cart {
  int? id;
  int? quantity;
  double? price;
  DateTime? dateAdded;
  String? isPurchase;
  int? productId;
  int? plantId;
  dynamic biddingId;
  int? userId;
  bool? isChecked;
  DateTime? createdAt;
  DateTime? updatedAt;

  Cart({
    this.id,
    this.quantity,
    this.price,
    this.dateAdded,
    this.isPurchase,
    this.productId,
    this.plantId,
    this.biddingId,
    this.userId,
    this.isChecked = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        isPurchase: json["is_purchase"],
        productId: json["product_id"],
        plantId: json["plant_id"],
        biddingId: json["bidding_id"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "quantity": quantity,
        "price": price,
        "date_added": dateAdded == null
            ? null
            : "${dateAdded!.year.toString().padLeft(4, '0')}-${dateAdded!.month.toString().padLeft(2, '0')}-${dateAdded!.day.toString().padLeft(2, '0')}",
        "is_purchase": isPurchase,
        "productID": productId.toString(),
        "plantID": plantId.toString(),
        "bidding_id": biddingId.toString(),
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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

class CheckBoxListTileModel {
  String title;
  bool isCheck;
  Cart cart;
  Plant? plant;
  Product? product;

  CheckBoxListTileModel({
    required this.title,
    required this.isCheck,
    required this.cart,
    this.plant,
    this.product,
  });
}
