import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Data/cart_model_class.dart';

class GetItemsCart with ChangeNotifier {

  List<CartStatus> cartDataList = [];
  var cartItemId = '';
  String total = '';
  bool isLoaded = true;
  bool? StatusCode;
  Future<List<CartStatus>> getCartData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwtToken = preferences.getString('jwtToken') ?? '';
      StatusCode = (preferences.getBool('statusCode') ?? '') as bool?;
      final response = await http.get(
        Uri.parse(
            "https://shopping-app-backend-t4ay.onrender.com/cart/getMyCart"),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );
      print('Response status code: ${response.statusCode}');
      final jsonresponse = jsonDecode(response.body);
      print('Response body: $jsonresponse');

      if (response.statusCode == 200) {

        var items = jsonresponse;
        print(items);
        cartDataList = [CartStatus.fromJson(items)];

        print('Cart data list: $cartDataList');
        return cartDataList;

      } else if (response.statusCode == 500) {
        StatusCode = false;
        SharedPreferences preferences =
        await SharedPreferences.getInstance();
        preferences.setBool('statusCode', StatusCode!);
       // Navigator.of(context as BuildContext).pushNamedAndRemoveUntil('/loginpage', (Route route) => route.settings.name =='/loginpage');
        throw Exception('Something went Wrong');
      }   else {
        var parsed = jsonDecode(response.body);
        print('Error response: $parsed');
        throw Exception('Failed to get cart data: ${parsed['message']}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to get cart data: $e');
    }
  }
}