import 'package:agri_com/screens/product_page.dart';
import 'package:agri_com/services/firebase_services.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccount createState() => _MyAccount();
}

class _MyAccount extends State<MyAccount> {
  final CollectionReference _userDetails =
      FirebaseFirestore.instance.collection('name');

  FirebaseServices _firebaseServices = FirebaseServices();

  File _image;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final _formKey = GlobalKey<FormState>();
    final picker = ImagePicker();
    TextEditingController _email = TextEditingController();
    TextEditingController _username = TextEditingController();
    String name = "";
    String email = "";

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = (await firebaseStorageRef.getDownloadURL()).toString();
      print(url);

      User _user = FirebaseAuth.instance.currentUser;
      final CollectionReference userDetails =
          FirebaseFirestore.instance.collection('name');

      Future _addDetails() {
        return _firebaseServices.userDetails
            .doc(_firebaseServices.getUserId())
            .collection("Details")
            .doc(_firebaseServices.getProductId())
            .set({"email": email, "username": name, "profilePicture": url});
      }

      _addDetails();
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.userDetails
                .doc(_firebaseServices.getUserId())
                .collection("Details")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 0.0,
                    bottom: 0.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                productId: document.id,
                              ),
                            ));
                      },
                      child: Column(
                        children: [
                          CustomActionBar(
                            title: "Profile",
                            hasProfile: false,
                            hasBackArrrow: true,
                            hasCart: true,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Color(0xffe0e0e0),
                                  child: ClipOval(
                                    child: new SizedBox(
                                      width: 155.0,
                                      height: 155.0,
                                      child: (imageUrl != null)
                                          ? Image.file(
                                              _image,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.network(
                                              "${document.data()['profilePicture']}" ??
                                                  "ProfilePicture",
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 120.0, right: 75),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    getImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 13.0),
                              ),
                              Text("Name :",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 320.0,
                                height: 80.0,
                                child: TextField(
                                  controller: _username,
                                  decoration: InputDecoration(
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(color : Colors.blue),
                                    //   borderRadius: BorderRadius.all(Radius.circular(10))
                                    // ),
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(color: Colors.red),
                                    //   borderRadius: BorderRadius.all(Radius.circular(30))
                                    // ),
                                    hintText:
                                        " ${document.data()['username']}" ??
                                            "Name",
                                  ),
                                ),
                                padding: EdgeInsets.all(20),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.black,
                                onPressed: () {
                                  email =
                                      "${document.data()['email']}" ?? "Email";
                                  name = _username.text;
                                  uploadPic(context);
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.all(13.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Email :',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold)),
                                Text("  ${document.data()['email']}" ?? "Email",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
