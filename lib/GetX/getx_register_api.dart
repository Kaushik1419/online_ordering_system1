import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class SignUpGetx extends GetxController{

  final  nameController = TextEditingController().obs;
  final  passController = TextEditingController().obs;
  final  emailIdController = TextEditingController().obs;
  final  mobileNoController = TextEditingController().obs;
  RxBool isLoaded = false.obs;
  String? userId;
  void register(
      String name, String emailId, String mobileNo, String password) async {
    isLoaded.value = true;
    try {
      var response = await post(
          Uri.parse(
              'https://shopping-app-backend-t4ay.onrender.com/user/registerUser'),
          body: {
            'name': nameController.value.text,
            'emailId': emailIdController.value.text,
            'mobileNo': mobileNoController.value.text,
            'password': passController.value.text,
          });
print(response.statusCode);
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        print(data);
        print(data['token']);
        isLoaded.value = false;
        print('Go to the OTP page');
        userId = data['data']['_id'];
        print('$userId');
       // Navigator.pushNamed(context, '/verificationpage', arguments: userId);
        Fluttertoast.showToast(
            msg: "Otp has been send to your Email",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16);
        Get.toNamed('/verificationpage', arguments: userId);
      } else if (response.statusCode == 400) {
        print("User already exist");
        isLoaded.value = false;
        Fluttertoast.showToast(
            msg: "User already exist!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}