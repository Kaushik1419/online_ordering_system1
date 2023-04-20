import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginGetX extends GetxController{
  bool StatusCode = false;
  final passwordController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  String code = "";
  String? name1;
  String? emailId;
  String? mobileNo;
  RxBool isLoading = false.obs;
  void login(String emailId, String password) async {
    isLoading.value = true;
    try {
      print(emailId);
      print(password);

      var response = await http.post(
          Uri.parse(
              'https://shopping-app-backend-t4ay.onrender.com/user/login'),
          body: {
            "emailId": emailController.value.text,
            "password": passwordController.value.text,
          });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var data = jsonDecode(response.body.toString());
        print(data);
        var value = data['data']['jwtToken'];
        name1 = data['data']['name'];
        StatusCode = true;
        emailId = data['data']['emailId'];
        mobileNo = data['data']['mobileNo'];
        // print(mobileNo);
        print('$value');
        addStringToTSF(value, name1!, emailId , mobileNo!, StatusCode);
        print('Login Successful');
       // Navigator.of(context).pushNamed('/navbar');

        StatusCode = true;
        Get.offAllNamed('/navbar');
      } else if (response.statusCode == 400) {
        isLoading.value = false;
        var data = jsonDecode(response.body.toString());
        print(data);
        print("Enter the valid value");
      }
    } catch (e) {
      print(e.toString());
    }
  }
  addStringToTSF(String value, String email, String name, String mobileNo, bool StatusCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('jwtToken', value);
    prefs.setString('name', name);
    prefs.setString('mobileNo', mobileNo);
    prefs.setBool('statusCode', true);
  }


}