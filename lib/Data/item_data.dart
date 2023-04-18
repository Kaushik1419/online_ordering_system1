import 'dart:convert';

ItemData postFromJson(String str) =>
ItemData.fromMap(json.decode(str));


String postToJson(ItemData data) => json.encode(data.toJson());

class ItemData {
  final int id;
  final String title;
  final int price;
  final String description;
  final String imageUrl;
  String? imageUrl2;
  String? imageUrl3;
  String? imageUrl4;
  String? imageUrl5;
  int quantity;

  int totalPrice;

  ItemData({required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.quantity = 1,
    this.totalPrice = 0,
    this.imageUrl2,
    this.imageUrl3,
    this.imageUrl4,
    this.imageUrl5});

  factory ItemData.fromMap(Map<String, dynamic> json) =>
      ItemData(
          id: json['_id'],
          title: json['title'],
          price: json['price'],
          description: json['description'],
          imageUrl: json['imgeUrl']);

  Map<String, dynamic> toJson() =>
      { '_id': id,
        'title': title,
        'price' : price,
        'description' : description,
        'imageUrlUrl' : imageUrl
      };
}
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
     this.status,
     this.msg,
     this.totalProduct,
    required this.data,
  });

  int? status;
  String? msg;
  int? totalProduct;
  List<Datum> data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    status: json["status"]?.toInt() ?? 0,
    msg: json["msg"] ?? '',
    totalProduct: json["totalProduct"]?.toInt() ?? 0,
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "totalProduct": totalProduct,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
  @override
  String toString()
  {
    return 'Welcome{status : $status, msg : $msg , totalProduct : $totalProduct , data : $data }';
  }
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.cartItemId,
    required this.quantity,
    required this.watchListItemId,
  });

  String id;
  String title;
  String description;
  String price;
  String imageUrl;
  String cartItemId;
  int quantity;
  String watchListItemId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"] ?? '',
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    price: json["price"] ?? '',
    imageUrl: json["imageUrl"] ?? '',
    cartItemId: json["cartItemId"] ?? '',
    quantity:json["quantity"] is String ? int.tryParse(json["quantity"] ?? '') ?? 0 : json["quantity"] ?? 0,
    watchListItemId: json["watchListItemId"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "price": price,
    "imageUrl": imageUrl,
    "cartItemId": cartItemId,
    "quantity": quantity,
    "watchListItemId": watchListItemId,
  };
  @override
  String toString()
  {
    return 'Datum{id:$id, title: $title, description: $description, price: $price, imageUrl: $imageUrl,cartItemId : $cartItemId, quantity : $quantity, watchListItemId : $watchListItemId }';
  }

}
