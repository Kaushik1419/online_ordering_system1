import 'dart:core';

import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

class UserInfo {
  String? name;
  String? emailId;
  String? mobileNo;
  String? password;
  String? id;
  String? createdAt;
  String? updatedAt;

  UserInfo(
      { required this.name,
       required this.emailId,
       required this.mobileNo,
      required this.password,
      this.id,
      this.createdAt,
      this.updatedAt});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
      name: json['name'],
      emailId: json['emailId'],
      mobileNo: json['mobileNo'],
      password: json['password'],
      createdAt: json['createdAt'],
      id: json['id']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'emailId': emailId,
        'mobileNo': mobileNo,
        'password': password,
        'id': id,
        'createdAt': createdAt
      };

}

class info{
 info({ this.id, this.status, this.msg});

 String? id;
 String? status;
 String? msg;

 factory info.fromJson(Map<String,dynamic> json) => info(
   id: json['_id'],
   status: json['status'],
   msg: json['msg']
 );

 Map<String, dynamic> toJson() => {
   "id" : id,
   "msg" : msg,
   "status" : status
 };
}