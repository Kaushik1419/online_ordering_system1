import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:online_ordering_system1/provider/get_cart_item_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'provider/cart_provider.dart';
import 'package:http/http.dart' as http;

class AddToCart extends StatefulWidget {
  const AddToCart({Key? key}) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  late FirebaseMessaging messaging;
  StreamSubscription? internetconnection;
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) => print(value));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          // context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            }, context: context);
      }
    });
  }
Future<void> sendNotification(String fcmToken)async {
  try{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? name = preferences.getString('email');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'key=AAAAq52bnXA:APA91bHIh1o35ysm9gJLkbra6CadZ2Zznkd7bwJJYVyNIG1Efw7pxHXc6AQmmVIVSn0ryyoiHPvlrYVXZ_pOLsNPz05BGEzSqtSFYzSp5Bi-Dsl-0z4fMQOCMAEtasCt83LT7tVFbAjR',
    };

    final body = {
      'to': fcmToken,
      'notification': {
        'title': 'Online Ordering System',
        'body': 'Hello! ${name} You have buy all the carted Items ',
        'sound': 'Default'
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      }
    };
    var request = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send')
        , headers: headers, body: json.encode(body));
    print(request.body);
  } catch(e)
  {
    print("hjgcshasgdhasd   ${e.toString()}");
  }
}
  @override
  Widget build(BuildContext context) {
    final getItemProvider = Provider.of<GetItemsCart>(context);
    final removeCartProvider = Provider.of<AddcartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: const Text(
          "Cart",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                  future: getItemProvider.getCartData(),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Lottie.asset('assets/lottie/lottie5.json');
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Lottie.asset('assets/lottie/lottie6.json');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return getItemProvider.cartDataList[0].data.isEmpty
                          ? Center(
                              child: Lottie.asset('assets/lottie/lottie4.json'),
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: ListView.builder(
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: getItemProvider
                                        .cartDataList[0].data.length,
                                        itemBuilder: (context, index) {
                                      print(
                                          "csdsdvdsvdvfdfdfdfdsfsd${getItemProvider.cartDataList[0].data.length}");
                                      return Card(
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
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade100),
                                                  ),
                                                  child: Image.network(
                                                    getItemProvider
                                                        .cartDataList[0]
                                                        .data[index]
                                                        .productDetails
                                                        .imageUrl,
                                                    height: 172,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.58,
                                                          child: ListTile(
                                                            leading: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              child:
                                                                  AutoSizeText(
                                                                getItemProvider
                                                                    .cartDataList[
                                                                        0]
                                                                    .data[index]
                                                                    .productDetails
                                                                    .title
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                            trailing: InkWell(
                                                              onTap: () async {
                                                                String
                                                                    cartItemId =
                                                                    getItemProvider
                                                                        .cartDataList[
                                                                            0]
                                                                        .data[
                                                                            index]
                                                                        .id
                                                                        .toString();
                                                                print(
                                                                    cartItemId);
                                                                removeCartProvider
                                                                    .removeToCart(
                                                                        cartItemId);
                                                              },
                                                              child: Icon(
                                                                CupertinoIcons
                                                                    .clear,
                                                                size: 15,
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
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "color:",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text("Black")
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0, top: 2),
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 5,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 14.0, top: 2.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          ' ₹${getItemProvider.cartDataList[0].data[index].productDetails.price.toString()}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: CupertinoColors
                                                                  .systemBlue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.0),
                                                    child: Row(
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            if (getItemProvider
                                                                    .cartDataList[
                                                                        0]
                                                                    .data[index]
                                                                    .quantity >=
                                                                1) {
                                                              String
                                                                  cartItemId =
                                                                  getItemProvider
                                                                      .cartDataList[
                                                                          0]
                                                                      .data[
                                                                          index]
                                                                      .id
                                                                      .toString();
                                                              print(cartItemId);
                                                              removeCartProvider
                                                                  .decreaseTheITem(
                                                                      cartItemId);
                                                            } else {
                                                              String
                                                                  cartItemId =
                                                                  getItemProvider
                                                                      .cartDataList[
                                                                          0]
                                                                      .data[
                                                                          index]
                                                                      .id
                                                                      .toString();
                                                              print(cartItemId);
                                                              removeCartProvider
                                                                  .removeToCart(
                                                                      cartItemId);
                                                            }
                                                          },
                                                          child: Text(
                                                            "-",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  fixedSize:
                                                                      const Size(
                                                                          15,
                                                                          15),
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  elevation: 3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white),
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        AutoSizeText(
                                                            getItemProvider
                                                                .cartDataList[0]
                                                                .data[index]
                                                                .quantity
                                                                .toString()),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            String cartItemId =
                                                                getItemProvider
                                                                    .cartDataList[
                                                                        0]
                                                                    .data[index]
                                                                    .id
                                                                    .toString();
                                                            print(cartItemId);
                                                            await removeCartProvider
                                                                .increaseTheITem(
                                                                    cartItemId);
                                                            getItemProvider
                                                                .cartDataList[0]
                                                                .data[index]
                                                                .quantity;
                                                            getItemProvider
                                                                .cartDataList[0]
                                                                .cartTotal;
                                                          },
                                                          child: Text(
                                                            "+",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  fixedSize:
                                                                      const Size(
                                                                          15,
                                                                          15),
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  elevation: 3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  1.1,
                                          child: Card(
                                            elevation: 5.0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 30.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: ListTile(
                                                      leading: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 3.0),
                                                        child: Text(
                                                          "Total Price",
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        getItemProvider
                                                            .cartDataList[0]
                                                            .cartTotal
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              String cartId = snapshot
                                                  .data![0].data[0].cartId;
                                              print(cartId);
                                              String cartTotal = snapshot
                                                  .data![0].cartTotal
                                                  .toString();
                                              removeCartProvider.placeOrder(
                                                  cartId, cartTotal);
                                              getItemProvider.cartDataList[0];
                                              SharedPreferences pref = await SharedPreferences.getInstance();
                                              String fcmToken = pref.getString('fcmToken') ?? '';
                                              print(fcmToken);
                                              sendNotification(fcmToken);
                                            },
                                            child: Text(
                                              "Buy Now",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                    }

                    return Center(
                      child: Lottie.asset('assets/lottie/lottie4.json'),
                    );
                  })),
        ),
      ),
    );
  }
}
