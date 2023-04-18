import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:online_ordering_system1/Data/order_item_model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderedItem extends StatefulWidget {
  const OrderedItem({Key? key}) : super(key: key);

  @override
  State<OrderedItem> createState() => _OrderedItemState();
}

class _OrderedItemState extends State<OrderedItem> {
  List<OrderData> data = [];
  Future<List<OrderData>> getOrderData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwtToken = preferences.getString('jwtToken') ?? '';
    final response = await http.get(
        Uri.parse(
            'https://shopping-app-backend-t4ay.onrender.com/order/getOrderHistory'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        });
    print('Token : ${jwtToken}');

    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body.toString());
      // print("test1111111");
      var items = parsed['data'];
      for (Map<String, dynamic> index in items) {
        data.add(OrderData.fromJson(index));
        // print(data);
      }
      return data;
    } else {
      throw Exception('Something went wrong!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: Text(
          "Ordered Items",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                          future: getOrderData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<OrderData>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade100),
                                                ),
                                                child: Image.network(
                                                  '${snapshot.data![index].imageUrl}',
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.7,
                                                        child: AutoSizeText(
                                                          '${
                                                            snapshot
                                                                .data![index]
                                                                .title
                                                          }',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors.grey
                                                                  .shade900),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  children: const [
                                                    Text(
                                                      "color:",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    Text("Black")
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.0, top: 2),
                                                child: Row(
                                                  children: [
                                                    Container( width: MediaQuery.of(context).size.width / 1.64,
                                                        child: AutoSizeText('${snapshot.data![index].description}', style: TextStyle(overflow: TextOverflow.ellipsis),maxLines: 1,))
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 9.0),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.64,
                                                      child: Text(
                                                          "₹${snapshot.data![index].price}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: CupertinoColors
                                                                  .systemBlue),
                                                        ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 9.0),
                                                    child: Container(
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                          1.64,
                                                      child: Text(
                                                        "${snapshot.data![index].createdAt}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: CupertinoColors
                                                                .systemGrey),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center( child: Lottie.asset(
                                  'assets/lottie/lottie5.json'));
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
