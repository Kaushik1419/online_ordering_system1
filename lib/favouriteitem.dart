import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:online_ordering_system1/Data/fav_model_class.dart';
import 'package:online_ordering_system1/provider/fav_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class FavouriteItem extends StatefulWidget {
  const FavouriteItem({Key? key}) : super(key: key);

  @override
  State<FavouriteItem> createState() => _FavouriteItemState();
}

class _FavouriteItemState extends State<FavouriteItem> {
  List<FavData> favDataList = [];
  var favItemId = '';
  bool isLoaded = true;

  Future<List<FavData>?> getFavData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jwtToken = preferences.getString('jwtToken') ?? '';
      String name = preferences.getString('name') ?? '';
      String mobileNo = preferences.getString('mobileNo') ?? '';
      String emailId = preferences.getString('email') ?? '';
      print(jwtToken);
      print(name);
      print(mobileNo);
      print(emailId);

      final response = await http.get(
          Uri.parse(
              'https://shopping-app-backend-t4ay.onrender.com/watchList/getWatchList'),
          headers: {
            'Authorization': 'Bearer $jwtToken',
          });
      if (response.statusCode == 200) {
        final jsonresponse = jsonDecode(response.body.toString());
        var items = jsonresponse['data'];
        List<FavData> templist = [];
        for (Map<String, dynamic> item in items) {
          var productDetails =
          ProductDetailsOfFav.fromJson(item['productDetails']);
          var favData = FavData.fromJson(item);
          favData.productDetails = productDetails;
          templist.add(favData);
          //print(favData);
          //  print(productDetails);
        }
        setState(() {
          favDataList = templist;
          isLoaded = false;
        });
        //print(favDataList.toString());
      } else if (response.statusCode == 500) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/loginpage', (Route route) => route.settings.name == '/loginpage');
        throw Exception('Something went Wrong');
      } else {
        var parsed = jsonDecode(response.body.toString());
        print(parsed);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getFavData();
  }
  @override
  Widget build(BuildContext context) {
    final removefavProvider = Provider.of<AddFavProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: const Text(
          "Favourite Items",
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
                          future: Future.value(favDataList),
                          builder: ( context,snapshot) {
                            //if (snapshot.hasData &&favDataList.isNotEmpty) {
                            return isLoaded
                                ? Center(
                                child: Lottie.asset(
                                    'assets/lottie/lottie5.json'))
                                : snapshot.hasData && favDataList.isNotEmpty
                                ? ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                FavData favData =
                                snapshot.data![index];
                                ProductDetailsOfFav productDetails =
                                    favData.productDetails;
                                return Container(
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior:
                                    Clip.antiAliasWithSaveLayer,
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
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(20),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .shade100),
                                              ),
                                              child: Image.network(
                                                '${productDetails.imageUrl}',
                                                height: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width /
                                                        1.7,
                                                    height: 50,
                                                    child: ListTile(
                                                      leading:
                                                      Container(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width /
                                                            2.9,
                                                        child:
                                                        AutoSizeText(
                                                          '${productDetails.title}',
                                                          style:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: Ink(
                                                        child:
                                                        InkWell(
                                                          onTap:
                                                              () async {
                                                            String
                                                            wathListItemId =
                                                            favDataList[index]
                                                                .id
                                                                .toString();
                                                            print(
                                                                wathListItemId);
                                                            await removefavProvider
                                                                .removeToFav(
                                                                wathListItemId);
                                                            getFavData();
                                                          },
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .suit_heart_fill,
                                                            color: Colors
                                                                .redAccent,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  left: 22.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "color:",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                  Text("Black")
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(
                                                  top: 2.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width /
                                                        1.64,
                                                    child: ListTile(
                                                      leading:
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left: 8),
                                                        child: Text(
                                                          "₹${productDetails.price}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: CupertinoColors
                                                                  .systemBlue),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                                : Column(children: [
                              Center(
                                  child: Lottie.asset(
                                      'assets/lottie/lottie4.json'))
                            ]);

                            //}
                            // else{
                            //   return Center(
                            //     child: CircularProgressIndicator(),
                            //   );
                            // }
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
