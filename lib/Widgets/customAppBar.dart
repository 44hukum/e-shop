import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Config/config.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
return AppBar(
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  flexibleSpace: Container(
    decoration: new BoxDecoration(
      gradient : new LinearGradient(
          colors: [Colors.pink, Colors.lightBlueAccent],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp,
      ),
    ),
  ),
  centerTitle: true,
  title: Text(
    "e-shop",
    style: TextStyle(fontSize: 55.0,
    color: Colors.white,
    fontFamily: "Signatra"),
  ),
  bottom: bottom,
  actions: [
    Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => CartPage());
            Navigator.pushReplacement(context, route);
          },
        ),
        Positioned(
          child: Stack(
            children: [
              Icon(
                Icons.brightness_1,
                size: 20.0,
                color: Colors.red,
              ),
              Positioned(
                top: 3.0,
                bottom: 4.0,
                left: 6.5,
                child: Consumer<CartItemCounter>(
                  builder: (context, counter, _) {
                    return Text(
                        (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    )
  ],
);


  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
