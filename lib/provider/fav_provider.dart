import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:online_ordering_system1/favouriteitem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class AddFavProvider with ChangeNotifier {
  String CartItemId = "";
  List<String> favouriteProductIds = [];
  FavouriteItem favouriteItem = new FavouriteItem();
  Map<String, dynamic> data = {};

  String? cartId;
  void addToFav(String productId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwtToken = preferences.getString('jwtToken') ?? '';

    try {
      String url =
          'https://shopping-app-backend-t4ay.onrender.com/watchList/addToWatchList';
      var requestBody = {"productId": productId};
      final header = {"Authorization": 'Bearer $jwtToken'};
      var response =
          await http.post(Uri.parse(url), headers: header, body: requestBody);
      print("test2222");

      var response1 = jsonDecode(response.body.toString());
      if (response.statusCode == 400) {
        print("something went wrong");
      } else {
        var response2 = jsonDecode(response.body.toString());
        print(response2);
        print('Testing for add to fav post');
        cartId = response1['data']['cartItemId'];
        data = response1['data']['productDetails'];
        favouriteProductIds.add(productId);
        //print(data);
        //print('$cartId');
        print('added to fav');

      }
    } catch (error) {
      print('AuthRepo.favcart.error: $error');
    }
    notifyListeners();
  }

   removeToFav(String wathListItemId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwtToken = preferences.getString('jwtToken') ?? '';
    print(jwtToken);
    String url =
        'https://shopping-app-backend-t4ay.onrender.com/watchList/removeFromWatchList';
    var body = {"wathListItemId": wathListItemId};
    print(wathListItemId);
    final header = {
      "Authorization": 'Bearer $jwtToken',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.post(Uri.parse(url), headers: header, body: body);
    print("ok to the remove to fav API");
    var parsed1 = await json.decode(json.encode(response.body.toString()));
    print(parsed1);
    if (response.statusCode == 200) {
      var parsed = await jsonDecode(response.body);
      print(parsed);
      print("successfully removed from the fav");
    } else {
      print("Something went wrong when using the removing data from the fav");
    }
    notifyListeners();
  }

  notifyListeners();
}
