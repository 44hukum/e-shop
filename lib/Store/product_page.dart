import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Config/config.dart';
import '../Models/rating.dart';



class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  final rateKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cUserId = TextEditingController();
  final cRating = TextEditingController();
  final cComment = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),

                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.itemModel.title,
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(widget.itemModel.longDescription,
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "£" + widget.itemModel.price.toString(),
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                    RatingBar.builder(
                      initialRating: 3,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          case 4:
                            return Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            );
                        }
                      },
                      onRatingUpdate: (rating) {
                        //creating a firestore and updating it
                        if(rateKey.currentState.validate()) {
                          final model = RatingModel(
                              userid: EcommerceApp.sharedPreferences.getString(
                                  EcommerceApp.userUID),
                              rating: rating.toString(),
                              productId: EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.productID),
                            comment: cComment.text

                          ).toJson();

                          //add to firestore
                          print(EcommerceApp.productID.toString());
                          EcommerceApp.firestore.collection('rating')
                              .doc(EcommerceApp.sharedPreferences.getString(
                              EcommerceApp.productID))
                              .set(model)
                              .then((value) {

                          });
                        }

                      },
                    ),
                        Card(
                          child: Form(
                            key: rateKey,
                            child: Column(
                              children: [
                                MyCommentField(
                                  hint: "Rate",
                                  controller: cComment,
                                )
                              ],
                            )
                          ) ,
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () => checkItemInCart(widget.itemModel
                            .shortInfo,context),
                        child: Container(
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [Colors.pinkAccent, Colors.blueAccent],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 40.0,
                          height: 50.0,
                          child: Center(
                            child: Text("Add to Cart",
                              style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCommentField extends StatelessWidget
{
  final String hint;
  final TextEditingController controller;

  MyCommentField({Key key, this.hint, this.controller,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field can not be empty." : null,
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
