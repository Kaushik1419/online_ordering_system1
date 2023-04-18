import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_ordering_system1/account.dart';
import 'package:online_ordering_system1/addtocart.dart';
import 'package:online_ordering_system1/favouriteitem.dart';
import 'package:online_ordering_system1/homescreen.dart';
import 'package:online_ordering_system1/order.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);


  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _index = 0;
  final screens = [
    HomeScreen(Producttitle: '',),
    FavouriteItem(),
    AddToCart(),
    OrderedItem(),
    Account()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CurvedNavigationBar(
          index: _index,
          onTap: (value){

             setState(() {
               _index = value;
             });
          },
          backgroundColor: Colors.grey.shade50,
          // animationDuration: const Duration(milliseconds: 600),
          items: const <Widget>[
            Icon(
              Icons.home_filled,
              size: 30,
            ),
            Icon(
              CupertinoIcons.heart_fill,
              size: 30,
            ),
            Icon(
              Icons.shopping_cart_rounded,
              size: 30,
            ),
            Icon(
              Icons.shopping_bag_rounded,
              size: 30,
            ),
            Icon(
              Icons.person_rounded,
              size: 30,
            )
          ],
        ),
      ),

    );
  }
}
