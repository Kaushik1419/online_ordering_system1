import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:online_ordering_system1/Data/item_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

class GetItems with ChangeNotifier {
  List<Welcome> data = [];
  List<String> ProductCartId = [];
  List<String> CartItemId = [];
  Future<List<Welcome>> getData({String? query, required BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwtToken = preferences.getString('jwtToken') ?? '';
    final response = await http.get(
        Uri.parse(
            'https://shopping-app-backend-t4ay.onrender.com/product/getAllProduct'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        });
    print('Token : ${jwtToken}');

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      var items = parsed;
      //print('sdaskdhajkshdjkas ${parsed}');

      data = [Welcome.fromJson(items)];
      if (query != null && query.isNotEmpty) {
        data = data.map((welcome) {
          final filteredData = welcome.data
              .where((product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return Welcome(data: filteredData);
        }).toList();
      }   else if (data.isEmpty) {
        return [];
      }
      //data = [Welcome.fromJson(items)];
     // print(data);
      return data;
    }
    else if (response.statusCode == 500) {
      Navigator.of(context).pushNamedAndRemoveUntil('/loginpage', (Route route) => route.settings.name =='/loginpage');
      throw Exception('Something went Wrong');
    }
    else {
      return data;
    }
  }
}
