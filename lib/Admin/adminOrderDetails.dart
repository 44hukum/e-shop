import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


String getOrderId="";
class AdminOrderDetails extends StatelessWidget
{
  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({Key key, this.orderID, this.orderBy, this.addressID,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders)
                .doc(getOrderId)
                .get(),
            builder: (c, snapshot)
            {
              Map dataMap;
              if(snapshot.hasData)
              {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                child: Column(
                  children: [
                    AdminStatusBanner(status: dataMap[EcommerceApp.isSuccess],),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "€ " + dataMap[EcommerceApp.totalAmount].toString(),
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text("Order ID: " + getOrderId),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Ordered at: " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore
                          .collection("items")
                          .where("shortInfo", whereIn: dataMap[EcommerceApp.productID])
                          .get(),
                      builder: (c, dataSnapshot)
                      {
                        return dataSnapshot.hasData
                            ? OrderCard(
                          itemCount: dataSnapshot.data.docs.length,
                          data: dataSnapshot.data.docs,
                        )
                            : Center(child: circularProgress(),);
                      },
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<DocumentSnapshot>(
                      future: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .doc(orderBy)
                          .collection(EcommerceApp.subCollectionAddress)
                          .doc(dataMap[EcommerceApp.addressID])
                          .get(),
                      builder: (c, snap)
                      {
                        return snap.hasData
                            ? AdminShippingDetails(model: AddressModel.fromJson(snap.data.data()),)
                            : Center(child: circularProgress(),);
                      },
                    ),
                  ],
                ),
              )
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final bool status;

  AdminStatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    String msg;
    IconData iconData;

    status ? iconData = Icons.circle : iconData = Icons.cancel;
    status ? msg = "Inprogress" : msg = "UnSuccessful";

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.pinkAccent, Colors.blueAccent],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],

        ),
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()
            {
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            "Order Shipped " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;

  AdminShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0,),
          child: Text(
            "Shipment Details:",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [

              TableRow(
                  children: [
                    KeyText(msg: "Name",),
                    Text(model.name),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Phone Number",),
                    Text(model.phoneNumber),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Flat Number",),
                    Text(model.flatNumber),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "City",),
                    Text(model.city),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "State",),
                    Text(model.state),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Pin Code",),
                    Text(model.pincode),
                  ]
              ),

            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                confirmParcelShifted(context, getOrderId);
              },
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
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Confirm || Parcel Shift",
                    style: TextStyle(color: Colors.white, fontSize: 15.0,),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmParcelShifted(BuildContext context, String mOrderId)
  {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Parcel has been Shifted. Confirmed.");
  }
}


