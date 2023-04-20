import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:online_ordering_system1/provider/cart_provider.dart';
import 'package:online_ordering_system1/provider/fav_provider.dart';
import 'package:online_ordering_system1/provider/get_Item_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Data/item_data.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  final String Producttitle;
  const HomeScreen({Key? key, required this.Producttitle}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final getItems1 = GetItems();
  late FirebaseMessaging messaging;
  StreamSubscription? internetconnection;
  bool isOffline = false;
  bool isFavPressed = false;
  Color cartColor = Colors.black;
  int activeIndex = 0;
  CarouselController buttonCarouselController = CarouselController();
  GetItems getItems = new GetItems();
  final List<Welcome> users = [];

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
    searchResults = List.from(users);
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isOffline = false;
        });
      }
    });
   // FirebaseCrashlytics.instance.crash();
  }

  List<Welcome> searchResults = [];
  void search(String query) {
    setState(() {
      searchResults = users
          .where((user) =>
              user.data[0].title.toLowerCase().contains(query.toLowerCase()) ||
              user.data[0].title.contains(query))
          .toList();
    });
  }

    Future<void> sendPushNotification(String fcmToken) async {
    try{
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'key=AAAAq52bnXA:APA91bHIh1o35ysm9gJLkbra6CadZ2Zznkd7bwJJYVyNIG1Efw7pxHXc6AQmmVIVSn0ryyoiHPvlrYVXZ_pOLsNPz05BGEzSqtSFYzSp5Bi-Dsl-0z4fMQOCMAEtasCt83LT7tVFbAjR',
    };

    final body = {
      'to': fcmToken,
      'notification': {
        'title': 'Online Ordering System',
        'body': 'Your product has been carted',
        'sound': 'iphone.wav'
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
    final addCartProvider = Provider.of<AddcartProvider>(context);
    final favItemProvider = Provider.of<AddFavProvider>(context);
    final getItemProvider = Provider.of<GetItems>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isOffline == true
                  ? Container(
                      child: Text("Internet connectin"),
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 50.0, left: 27.0),
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                onTap: () {
                                  showSearch(
                                      context: context,
                                      delegate: MySearchDelegate());
                                },
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  prefixIcon: Icon(Icons.search_rounded),
                                  hintText: "Search the products here",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(40, 40),
                                  backgroundColor: Colors.grey[100],
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  )),
                              child: const Icon(
                                Icons.notifications_active,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 1,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 27),
                  child: Text(
                    "Products",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 27),
                  child: Text(
                    "Here best offer and top deal offers",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                indent: 1,
              ),
              FutureBuilder(
                  future: getItemProvider.getData(context: context),
                  builder: (context, snapshot) {
                    // print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        //   print(snapshot.data);
                        // print(items);
                        return GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.67, crossAxisCount: 2),
                          itemCount: getItemProvider.data[0].data.length,
                          itemBuilder: (BuildContext context, index) {
                            String productId =
                                getItemProvider
                                    .data[0]
                                    .data[index]
                                    .id;
                            //  print("${getItemProvider.data[0].data[index]}");
                            return Container(
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(17),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/detailitem',
                                                          arguments: {
                                                            'idArg':
                                                                getItemProvider
                                                                    .data[0]
                                                                    .data[index]
                                                                    .id,
                                                            'titleArg':
                                                                getItemProvider
                                                                    .data[0]
                                                                    .data[index]
                                                                    .title,
                                                            'priceArg':
                                                                getItemProvider
                                                                    .data[0]
                                                                    .data[index]
                                                                    .price,
                                                            'descriptionArg':
                                                                getItemProvider
                                                                    .data[0]
                                                                    .data[index]
                                                                    .description,
                                                            'imageUrlArg':
                                                                getItemProvider
                                                                    .data[0]
                                                                    .data[index]
                                                                    .imageUrl
                                                                    .toString(),
                                                          });
                                                    });
                                                  },
                                                  child: Image.network(
                                                    getItemProvider.data[0]
                                                        .data[index].imageUrl
                                                        .toString(),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.1,
                                                    height: 160,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        getItemProvider.data[0].data[index]
                                                    .watchListItemId
                                                    .toString() !=
                                                ''
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  favItemProvider.removeToFav(
                                                      getItemProvider
                                                          .data[0]
                                                          .data[index]
                                                          .watchListItemId
                                                          .toString());
                                                },
                                                child: Icon(
                                                  CupertinoIcons.heart_fill,
                                                  color: Colors.red,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    backgroundColor:
                                                        Colors.white),
                                              )
                                            : ElevatedButton(
                                                onPressed: () {
                                                  favItemProvider.addToFav(
                                                      getItemProvider.data[0]
                                                          .data[index].id
                                                          .toString());
                                                },
                                                child: Icon(
                                                  CupertinoIcons.heart,
                                                  color: Colors.black,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    backgroundColor:
                                                        Colors.white),
                                              )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.0, left: 8, right: 8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${getItemProvider.data[0].data[index].title}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8, left: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            '₹${getItemProvider.data[0].data[index].price}',
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.2),
                                          child: getItemProvider.data[0]
                                                      .data[index].quantity >
                                                  0
                                              ? Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0),
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          String cartItemId =
                                                              getItemProvider
                                                                  .data[0]
                                                                  .data[index]
                                                                  .cartItemId
                                                                  .toString();
                                                          //print(cartItemId);
                                                          addCartProvider
                                                              .decreaseTheITem(
                                                                  cartItemId);
                                                        },
                                                        child: Text(
                                                          "-",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    const CircleBorder(),
                                                                elevation: 3,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      getItemProvider.data[0]
                                                          .data[index].quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        String cartItemId =
                                                            await getItemProvider
                                                                .data[0]
                                                                .data[index]
                                                                .cartItemId
                                                                .toString();
                                                        print(cartItemId);
                                                        addCartProvider
                                                            .increaseTheITem(
                                                                cartItemId);
                                                      },
                                                      child: Text(
                                                        "+",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              fixedSize:
                                                                  const Size(
                                                                      7, 7),
                                                              shape:
                                                                  const CircleBorder(),
                                                              elevation: 3,
                                                              backgroundColor:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.29,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      addCartProvider
                                                          .addToCart(productId);
                                                      print(
                                                          'productId: ${productId}');
                                                      String? fcmToken = await FirebaseMessaging.instance.getToken();
                                                      print(fcmToken);
                                                      await sendPushNotification(fcmToken!);
                                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                                      pref.setString('fcmToken', fcmToken);
                                                      getItemProvider.getData(context: context);
                                                    },
                                                    child: Text("Add to Cart"),
                                                  ),
                                                ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Lottie.asset('assets/lottie/lottie6.json'),
                        );
                      }
                    } else {
                      return Text('${snapshot.connectionState}');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = "",
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
        }
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final addCartProvider = Provider.of<AddcartProvider>(context);
    final favItemProvider = Provider.of<AddFavProvider>(context);
    final getItemProvider = Provider.of<GetItems>(context);
    return Container(
        child: FutureBuilder(
            future: getItemProvider.getData(query: query, context: context),
            builder: (context, snapshot) {
              //  print(snapshot.data);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  //   print(snapshot.data);
                  // print(items);
                  return Consumer<GetItems>(
                      builder: (context, getItemProvider, child) {
                    return GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.86, crossAxisCount: 2),
                      itemCount: getItemProvider.data[0].data.length,
                      itemBuilder: (BuildContext context, index) {
                        //  print("${getItemProvider.data[0].data[index]}");
                        return Container(
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(17),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Image.network(
                                                getItemProvider.data[0]
                                                    .data[index].imageUrl
                                                    .toString(),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.1,
                                                height: 100,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Consumer<AddFavProvider>(
                                        builder: (context, value, child) {
                                      return getItemProvider.data[0].data[index]
                                                  .watchListItemId
                                                  .toString() !=
                                              ''
                                          ? ElevatedButton(
                                              onPressed: () {
                                                value.removeToFav(
                                                    getItemProvider
                                                        .data[0]
                                                        .data[index]
                                                        .watchListItemId
                                                        .toString());
                                              },
                                              child: Icon(
                                                CupertinoIcons.heart_fill,
                                                color: Colors.red,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  backgroundColor:
                                                      Colors.white),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                favItemProvider.addToFav(
                                                    getItemProvider
                                                        .data[0].data[index].id
                                                        .toString());
                                              },
                                              child: Icon(
                                                CupertinoIcons.heart,
                                                color: Colors.black,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  backgroundColor:
                                                      Colors.white),
                                            );
                                    })
                                  ],
                                ),

                                Text(
                                    '${getItemProvider.data[0].data[index].title}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                                    textAlign: TextAlign.left,

                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8, left: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        '₹${getItemProvider.data[0].data[index].price}',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Consumer<AddcartProvider>(
                                          builder: (context, value, child) {
                                        return getItemProvider.data[0]
                                                    .data[index].quantity >
                                                0
                                            ? Row(
                                                children: [
                                                  Consumer<AddcartProvider>(
                                                    builder: (context, value,
                                                            child) =>
                                                        ElevatedButton(
                                                      onPressed: () async {
                                                        String cartItemId =
                                                            value
                                                                .data[0]
                                                                .data[index]
                                                                .cartItemId
                                                                .toString();
                                                        print(cartItemId);
                                                        addCartProvider
                                                            .decreaseTheITem(
                                                          cartItemId,
                                                        );
                                                      },
                                                      child: Text(
                                                        "-",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape:
                                                                  const CircleBorder(),
                                                              elevation: 3,
                                                              backgroundColor:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Consumer<AddcartProvider>(
                                                    builder: (context, value,
                                                            child) =>
                                                        Text(
                                                      getItemProvider.data[0]
                                                          .data[index].quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Consumer<AddcartProvider>(
                                                    builder: (context, value,
                                                            child) =>
                                                        ElevatedButton(
                                                      onPressed: () async {
                                                        String cartItemId =
                                                            await getItemProvider
                                                                .data[0]
                                                                .data[index]
                                                                .cartItemId
                                                                .toString();
                                                        print(cartItemId);
                                                        value.increaseTheITem(
                                                            cartItemId);
                                                      },
                                                      child: Text(
                                                        "+",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              fixedSize:
                                                                  const Size(
                                                                      7, 7),
                                                              shape:
                                                                  const CircleBorder(),
                                                              elevation: 3,
                                                              backgroundColor:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.29,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    String productId =
                                                        getItemProvider.data[0]
                                                            .data[index].id;
                                                    addCartProvider
                                                        .addToCart(productId);
                                                    getItemProvider.getData(context: context);

                                                    print(
                                                        'productId: ${productId}');
                                                  },
                                                  child: Text("Add to Cart"),
                                                ),
                                              );
                                      }),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
                } else {
                  return Center(
                    child: Text('empty'),
                  );
                }
              } else {
                return Text('${snapshot.connectionState}');
              }
            }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search the Items here"),
    );
  }
}
