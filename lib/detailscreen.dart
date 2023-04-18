import 'dart:async';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailItem extends StatefulWidget {
  const DetailItem({Key? key}) : super(key: key);

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  bool isLoading = true;
  late Map<String, dynamic> arguments = {};
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      arguments = await ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>;
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    print('test');
  }

  int pageindex = 0;
  late List<Widget> _demo = [
    Container(
      height: 400,
      child: Image.network(
        '${arguments['imageUrlArg']}',
        fit: BoxFit.fill,
      ),
    ),
    Container(
      height: 400,
      child: Image.network(
        '${arguments['imageUrlArg']}',
        fit: BoxFit.fill,
      ),
    ),
    Container(
      height: 400,
      child: Image.network(
        '${arguments['imageUrlArg']}',
        fit: BoxFit.fill,
      ),
    ),
    Container(
      height: 400,
      child: Image.network(
        '${arguments['imageUrlArg'].toString()}',
        fit: BoxFit.fill,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    print('${arguments['imageUrlArg'].toString()}');
    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   child: SizedBox(
      //     height: 60,
      //     child: Row(
      //       mainAxisSize: MainAxisSize.max,
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: <Widget>[
      //         Expanded(
      //             child: ElevatedButton(
      //           onPressed: () {},
      //           style: ElevatedButton.styleFrom(
      //               foregroundColor: Colors.grey,
      //               backgroundColor: Colors.grey.shade100,
      //               shape: const RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.zero)),
      //           child: const Text(
      //             "Add to Cart",
      //             style: TextStyle(color: Colors.blue),
      //           ),
      //         )),
      //         Expanded(
      //             child: ElevatedButton(
      //                 onPressed: () {
      //                   setState(() {});
      //                 },
      //                 style: ElevatedButton.styleFrom(
      //                     shape: const RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.zero)),
      //                 child: const Text("Buy Now")))
      //       ],
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Stack(
              children: [
                isLoading
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 400,
                                width: double.infinity,
                                child: PageView(
                                  children: _demo,
                                  onPageChanged: (index) {
                                    setState(() {
                                      pageindex = index;
                                    });
                                  },
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListTile(
                                          leading: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const Icon(
                                                Icons.arrow_back_ios_new),
                                            color: Colors.black,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.share),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 322,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CarouselIndicator(
                                        index: pageindex,
                                        count: _demo.length,
                                        color: Colors.grey.shade300,
                                        activeColor: Colors.blue,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${arguments['titleArg']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.grey.shade700),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "₹${arguments['priceArg']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23,
                                          color: Colors.blue),
                                    ),

                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      itemSize: 30,
                                      initialRating: 0,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 5,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Porduct Details:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${arguments['descriptionArg']}",
                                      style: TextStyle(
                                          fontSize: 15.5,
                                          color: Colors.grey.shade600),
                                    )
                                  ],
                                ),
                              ],
                            ),
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
