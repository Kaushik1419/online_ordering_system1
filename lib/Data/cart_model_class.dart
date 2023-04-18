import 'dart:convert';

CartStatus CartStatusFromJson(String str) => CartStatus.fromJson(json.decode(str));

String CartStatusToJson(CartStatus data) => json.encode(data.toJson());

class CartStatus {
  CartStatus({
    required this.status,
    required this.msg,
    required this.cartTotal,
    required this.data,
  });

  int status;
  String msg;
  double cartTotal;
  List<CartData> data;

  factory CartStatus.fromJson(Map<String, dynamic> json) => CartStatus(
    status: json["status"] ?? '',
    msg: json["msg"] ?? '',
    cartTotal: json["cartTotal"]?.toDouble() ?? 0.00,
    data: List<CartData>.from((json["data"] ?? []).map((x) => CartData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "cartTotal": cartTotal,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
  @override
  String toString() {
    return 'CartData{status : $status, msg : $msg, cartTotal : $cartTotal, data : $data}';
  }
}

class CartData {
  CartData({
    required this.id,
    required this.userId,
    required this.cartId,
    required this.quantity,
    required this.itemTotal,
    required this.productDetails,
  });

  String id;
  String userId;
  String cartId;
  int quantity;
  int itemTotal;
  ProductDetailsOfCart productDetails;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    id: json["_id"].toString() ?? '',
    userId: json["userId"].toString() ?? '',
    cartId: json["cartId"].toString() ?? '',
    quantity: json["quantity"] is String ? int.tryParse(json["quantity"] ?? 0) : json["quantity"] ?? 0,
    itemTotal: json["itemTotal"] is String ? int.tryParse(json["itemTotal"].toInt() ?? 0) : json["itemTotal"].toInt() ?? 0,
    productDetails: ProductDetailsOfCart.fromJson(json["productDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "cartId": cartId,
    "quantity": quantity,
    "itemTotal": itemTotal,
    "productDetails": productDetails.toJson(),
  };
  @override
  String toString() {
    return 'CartData{id: $id, userId: $userId, cartId: $cartId, quantity: $quantity, itemTotal: $itemTotal, productDetails : $productDetails}';
  }
}

class ProductDetailsOfCart {
  ProductDetailsOfCart({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  String id;
  String title;
  String description;
  double price;
  String imageUrl;

  factory ProductDetailsOfCart.fromJson(Map<String, dynamic> json) => ProductDetailsOfCart(
    id: json["_id"].toString() ?? '' ,
    title: json["title"].toString() ?? '' ,
    description: json["description"].toString() ?? '' ,
    price: json["price"] is String ? double.tryParse(json["price"]) ?? 0.00: json["price"] ?? 0.00 ,
    imageUrl: json["imageUrl"].toString() ?? '' ,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "price": price,
    "imageUrl": imageUrl,
  };
  @override
  String toString() {
    return 'ProductDetailsOfCart{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl,}';
  }
}
