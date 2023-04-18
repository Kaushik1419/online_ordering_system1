import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:online_ordering_system1/provider/get_Item_provider.dart';
import 'package:online_ordering_system1/provider/get_cart_item_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddcartProvider with ChangeNotifier {
  String CartItemId = "";

  Map<String, dynamic> data = {};

  String? cartId;
  void addToCart(String productId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwtToken = preferences.getString('jwtToken') ?? '';

    try {
      String url =
          'https://shopping-app-backend-t4ay.onrender.com/cart/addToCart';
      var requestBody = {"productId": productId};
      final header = {"Authorization": 'Bearer $jwtToken'};
      var response =
          await http.post(Uri.parse(url), headers: header, body: requestBody);
      print("test2222");

      var response1 = jsonDecode(response.body.toString());
      if (response.statusCode == 400) {
        print("something went wrong");
      } else {
        print(response1);
        print('Testing for add to cart post');
        cartId = response1['data']['cartItemId'];
        data = response1['data']['productDetails'];
        // GetItems getItems = new GetItems();
        // getItems.getData(context: context);
        //print(data);
        //print('$cartId');
        print('added to cart');
      }
    } catch (error) {
      print('AuthRepo.favcart.error: $error');
    }
    notifyListeners();
  }

  void removeToCart(cartItemId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwtToken = preferences.getString('jwtToken') ?? '';
      print(jwtToken);
      String url =
          'https://shopping-app-backend-t4ay.onrender.com/cart/removeProductFromCart';
      var requestBody = {"cartItemId": cartItemId};
      print(cartItemId);
      final header = {"Authorization": 'Bearer $jwtToken'};
      var response =
          await http.post(Uri.parse(url), headers: header, body: requestBody);
      print("ok to the remove to cart API");

      if (response.statusCode == 200) {
        var parsed = jsonDecode(response.body);
        print(parsed);
        print("successfully removed from the cart");
        GetItemsCart getItemsCart = new GetItemsCart();
        getItemsCart.cartDataList[0].data[0].productDetails;
      } else {
        print(
            "Something went wrong when using the removing data from the cart");
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

   increaseTheITem(cartItemId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwtToken = preferences.getString('jwtToken') ?? '';
      print(jwtToken);
      String url =
          'https://shopping-app-backend-t4ay.onrender.com/cart/increaseProductQuantity';
      var requsetbody = {'cartItemId': cartItemId};
      print(cartItemId);
      final header = {"Authorization": 'Bearer $jwtToken'};
      var response =
          await http.post(Uri.parse(url), headers: header, body: requsetbody);
      print("Success full to the API calling in the increament");

      if (response.statusCode == 200) {
        var parsed = jsonDecode(response.body.toString());
        print(parsed);
        print("successfully run the 200 status code in the increament");
        print("successfully increased the price");
        notifyListeners();
      } else {
        var parsed = jsonDecode(response.body.toString());
        print(parsed);
        print("Something went wrong while doing increament in the price");
      }
    } catch (e) {
      print('increase error : ${e.toString()}');
    }
    notifyListeners();
  }

  void decreaseTheITem(cartItemId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwtToken = preferences.getString('jwtToken') ?? '';
      print(jwtToken);
      String url =
          'https://shopping-app-backend-t4ay.onrender.com/cart/decreaseProductQuantity';
      var requsetbody = {'cartItemId': cartItemId};
      print(cartItemId);
      final header = {"Authorization": 'Bearer $jwtToken'};
      var response =
          await http.post(Uri.parse(url), headers: header, body: requsetbody);
      print("Success full to the API calling in the decrement");

      if (response.statusCode == 200) {
        var parsed = jsonDecode(response.body.toString());
        print(parsed);
        print("successfully run the 200 status code in the decrement");
        print("successfully decrement the item");
      } else {
        var parsed = jsonDecode(response.body.toString());
        print(parsed);
        print("Something went wrong while doing decrement in the item");
      }
    } catch (e) {
      print('increase error : ${e.toString()}');
    }
    notifyListeners();
  }

  void placeOrder(String cartId, String cartTotal) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwtToken = preferences.getString('jwtToken') ?? '';
      final response = await http.post(
          Uri.parse(
              "https://shopping-app-backend-t4ay.onrender.com/order/placeOrder"),
          headers: {'Authorization': 'Bearer $jwtToken'},
          body: {'cartId': cartId, 'cartTotal': cartTotal});
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body.toString());
        print(responseBody.toString());
        print("Place Order");
        notifyListeners();
      } else {
        print("Something went wrong while adding to cart");
      }
    } catch (e) {
      print("Error in the place order is ${e.toString()}");
    }
    notifyListeners();
  }

  notifyListeners();
}
