// To parse this JSON data, do
//
//     final OrderStatus = OrderStatusFromJson(jsonString);

import 'dart:convert';

OrderStatus OrderStatusFromJson(String str) => OrderStatus.fromJson(json.decode(str));

String OrderStatusToJson(OrderStatus data) => json.encode(data.toJson());

class OrderStatus {
  OrderStatus({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  List<OrderData> data;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    status: json["status"],
    msg: json["msg"],
    data: List<OrderData>.from(json["data"].map((x) => OrderData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderData {
  OrderData({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.productTotalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String userId;
  String orderId;
  String productId;
  String title;
  String description;
  String price;
  String imageUrl;
  int quantity;
  String productTotalAmount;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id: json["_id"],
    userId: json["userId"],
    orderId: json["orderId"],
    productId: json["productId"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    quantity: json["quantity"],
    productTotalAmount: json["productTotalAmount"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "orderId": orderId,
    "productId": productId,
    "title": title,
    "description": description,
    "price": price,
    "imageUrl": imageUrl,
    "quantity": quantity,
    "productTotalAmount": productTotalAmount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
