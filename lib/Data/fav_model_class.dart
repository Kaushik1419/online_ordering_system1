import 'dart:convert';

FavStatus? FavStatusFromJson(String str) {
  if (str == null)
    return null;
  FavStatus.fromJson(json.decode(str));}

String FavStatusToJson(FavStatus data) => json.encode(data.toJson());

class FavStatus {
  FavStatus({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  List<FavData> data;

  factory FavStatus.fromJson(Map<String, dynamic> json) => FavStatus(
        status: json["status"],
        msg: json["msg"],
        data: List<FavData>.from(json["data"].map((x) => FavData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FavData {
  FavData({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.productDetails,
  });

  String id;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  ProductDetailsOfFav productDetails;

  factory FavData.fromJson(Map<String, dynamic> json) => FavData(
        id: json["_id"].toString() ?? '',
        userId: json["userId"].toString() ?? '',
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        productDetails: ProductDetailsOfFav.fromJson(json["productDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "productDetails": productDetails.toJson(),
      };
  @override
  String toString() {
    return 'favDataList{id : $id, userId : $userId, createdAt : $createdAt, updateAt : $updatedAt, v: $v}';
  }
}

class ProductDetailsOfFav {
  ProductDetailsOfFav({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  int v;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductDetailsOfFav.fromJson(Map<String, dynamic> json) =>
      ProductDetailsOfFav(
        id: json["_id"].toString() ?? '',
        title: json["title"].toString() ?? '',
        description: json["description"].toString() ?? '',
        price: json["price"] is String
            ? double.tryParse(json["price"]) ?? 0.00
            : json["price"] ?? 0.00,
        imageUrl: json["imageUrl"].toString() ?? '',
        v: json["__v"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "price": price,
        "imageUrl": imageUrl,
        "__v": v,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
  @override
  String toString() {
    return 'ProductDetailsOfFav {id : $id, title : $title, description : $description, price : $price, imageUrl : $imageUrl, v : $v, createdAt : $createdAt, updatedAt : $updatedAt}';
  }
}
