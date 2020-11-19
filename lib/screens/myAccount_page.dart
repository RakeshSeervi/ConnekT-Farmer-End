import 'dart:io';

import 'package:agri_com/services/firebase_services.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccount createState() => _MyAccount();
}

class _MyAccount extends State<MyAccount> {
  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = "Initial Text";
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
  }
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }


  final CollectionReference _userDetails =
      FirebaseFirestore.instance.collection('name');

  FirebaseServices _firebaseServices = FirebaseServices();

  File _image;
  String imageUrl;
  File croppedImage;

  var _autovalidate = false;

  @override
  Widget build(BuildContext context) {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final _formKey = GlobalKey<FormState>();
    final picker = ImagePicker();
    TextEditingController _email = TextEditingController();
    TextEditingController _username = TextEditingController();
    String name = "";
    String email = "";
    String profile = "";
    String url = "";










    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      url = (await firebaseStorageRef.getDownloadURL()).toString();
      print(url);

      User _user = FirebaseAuth.instance.currentUser;
      final CollectionReference userDetails =
          FirebaseFirestore.instance.collection('name');

      Future _addProfile() {
        return _firebaseServices.userDetails
            .doc(_firebaseServices.getUserId())
            .collection("Details")
            .doc(_firebaseServices.getProductId())
            .update({"profilePicture": url});
      }

      _addProfile();
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }
    Future getImage() async {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if(image !=null){
        croppedImage = await ImageCropper.cropImage(sourcePath: image.path,aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepOrange,
              toolbarTitle: "Crop",
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white,
            ));

      }


      setState(() {
        _image = croppedImage;
        print('Image Path $_image');
      });
      uploadPic(context);
    }
    Future _addUserName() async{
      return _firebaseServices.userDetails
          .doc(_firebaseServices.getUserId())
          .collection("Details")
          .doc(_firebaseServices.getProductId())
          .update({"username": name});
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ProductPage(
                        //         productId: document.id,
                        //       ),
                        //     ));
                      },
                      child: Column(
                        children: [
                          CustomActionBar(
                            title: "Profile",
                            hasBackArrrow: true,
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
                                      child: (_image != null)
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
                          Form(
                            key: _formKey,
                            autovalidate: _autovalidate,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 00),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10, left: 23, right: 23),
                                  child: TextFormField(
                                    controller: _username,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                        hintText: "${document.data()['username']}" ??
                                            "Name",
                                      prefixIcon: Icon(Icons.account_circle),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Username cannot be empty!';
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  margin: EdgeInsets.all(25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Email :',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold)),
                                      Text("  ${document.data()['email']}" ?? "Email",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 250.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.black)),
                                        color: Colors.black,
                                        textColor: Colors.red,
                                    padding: EdgeInsets.all(8.0),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                      ),
                                    FlatButton(
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.black)),
                                      color: Colors.black,
                                      textColor: Colors.red,
                                        onPressed: () {
                                          if (_formKey.currentState.validate()){
                                            name = _username.text;
                                            _addUserName();
                                            setState(() {
                                              print("Profile Picture uploaded");
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(content: Text('UserName Changed')));
                                            });

                                          }
                                          else
                                            setState(() {
                                              _autovalidate = true;
                                              Future<void> _alertDialogBuilder(String error) async {
                                                return showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text("Error"),
                                                        content: Container(
                                                          child: Text(error),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text("Close Dialog"),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                              _alertDialogBuilder("Username Empty");
                                            });
                                        },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 16.0),
                                        ),
                                      ),
                                  ],
                                ),

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




