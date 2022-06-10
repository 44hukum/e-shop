import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}



class _UpdateProfileState extends State<UpdateProfile>
{
  TextEditingController _nameTextEditingController =TextEditingController();
   final TextEditingController _emailTextEditingController =TextEditingController();
  final TextEditingController _passwordTextEditingController =TextEditingController();
  final TextEditingController _cPasswordTextEditingController =TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl= "";
  File _imageFile;



  @override
  Widget build(BuildContext context) {
    double _screenWidth= MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0,),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth *0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile==null
                    ? null: FileImage(_imageFile),
                child:_imageFile == null
                    ? Icon(Icons.add_photo_alternate, size: _screenWidth*0.15,color: Colors.grey,)
                    :null,
              ),
            ),
            SizedBox(height: 8.0,),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller:_emailTextEditingController ,
                    data:Icons.email ,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,

                  ),
                  CustomTextField(
                    controller: _cPasswordTextEditingController,
                    data: Icons.person,
                    hintText: "Confirm Password",
                    isObsecure: true,

                  ),
                ],
              ),
            ),

            RaisedButton(
              onPressed:(){ uploadAndSaveImage();},
              color:Colors.pink ,
              child: Text("Update Profile", style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth =0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],

        ),
      ),
    );
  }



  final _picker = ImagePicker();
  void _selectAndPickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: 'Please select an image..',
            );
          });
    } else {
      _passwordTextEditingController.text ==
          _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
          _cPasswordTextEditingController.text.isNotEmpty &&
          _nameTextEditingController.text.isNotEmpty
          ? updateToStorage()
          : displayDialog('Please complete the registration form..')
          : displayDialog('Passwords do not match!');
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  updateToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Processing update, please wait....',
          );
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference =
    FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask storageUploadTask = storageReference.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await storageUploadTask;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
        saveUserInfoToFireStore();
    });
  }



  Future saveUserInfoToFireStore() async
  {
    print(FirebaseAuth.instance.currentUser);
    FirebaseAuth.instance.currentUser.updateEmail(_emailTextEditingController.text);
    FirebaseAuth.instance.currentUser.updatePassword(_passwordTextEditingController.text);
    FirebaseFirestore.instance.collection("users").doc(EcommerceApp.userUID).update({
      "email": _emailTextEditingController.text,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList:["garbageValue"],
    });
       await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, _emailTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,["garbageValue"]);
    Navigator.pop(context);
  }
}



class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;

  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          )),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
         decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
