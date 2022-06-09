import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Authentication/authenication.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
         backgroundColor: Colors.pink,
          centerTitle: true,
          title: Text("All Orders", style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.black,),
              onPressed: ()
              {
                EcommerceApp.auth.signOut().then((c) {
                  Route route = MaterialPageRoute(builder: (c) => AuthenticScreen());
                  Navigator.pushReplacement(context, route);
                });
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.pink,
          child: ListView(
            children: [
              Container(
                child: Image.asset(
                  "images/admin.png",
                  height: 240.0,
                  width: 240.0,
                ),
              ),
              Card(
                child:  ListTile(
                  onTap: ()=>{

                    Navigator.push(context, MaterialPageRoute(builder: (c) => UploadPage()))
                  },
                  leading: Icon(Icons.upload),
                  title: Text('Upload Items'),


                ),
              ),
              Card(
                child:  ListTile(
                  onTap: ()=>{
                  EcommerceApp.auth.signOut().then((c) {
                  Route route =
                  MaterialPageRoute(builder: (c) => AuthenticScreen());
                  Navigator.pushReplacement(context, route);
                  })
                  },
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),


                ),
              )

            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .snapshots(),
          builder: (c, snapshot)
          {

            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (c, index){
                   return snapshot.hasData
                        ? AdminOrderCard(
                      itemCount: snapshot.data.docs.length,
                      data: snapshot.data.docs,
                      orderID: snapshot.data.docs[index].id,
                      orderBy: snapshot.data.docs[index]["orderBy"],
                      addressID: snapshot.data.docs[index]["addressID"],
                    )
                        : Center(child: circularProgress(),);
                  },
            )
                :Center(child: Text("No-Orders",style: TextStyle(
                color: Colors.pink
            ),),);
          },
        ),
      ),
    );
  }
}
