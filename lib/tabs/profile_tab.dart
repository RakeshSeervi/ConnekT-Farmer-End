import 'package:agri_com/screens/login_page.dart';
import 'package:agri_com/screens/myAccount_page.dart';
import 'package:agri_com/screens/settings_page.dart';
import 'package:agri_com/services/firebase_services.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileTab > {


  String _defaultImage = 'assets/images/user.png';
  FirebaseServices _firebaseServices = FirebaseServices();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  Widget build(BuildContext context) {
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
                    top: 108.0,
                    bottom: 12.0,
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
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: new UserAccountsDrawerHeader(
                                accountName: Text(
                                    "${document.data()['username']}" ??
                                        "Username" ,
                                  style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                                ),
                                accountEmail: Text(
                                    "${document.data()['email']}" ?? "Email",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),

                                currentAccountPicture: Container(
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 350.0,
                                        child: ClipOval(
                                          child: new SizedBox(
                                            width: 180.0,
                                            height: 180.0,
                                            child: Image.network(
                                              "${document.data()['profilePicture']}" ??
                                                  "ProfilePicture",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                decoration:
                                    new BoxDecoration(color: Colors.transparent),
                              ),
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
          ListView(
              padding: EdgeInsets.only(
                top: 330.0,
                bottom: 12.0,
              ),
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyAccount(),
                                ));
                          },
                          child: ListTile(
                            title: Text("My Account"),
                            leading: Icon(Icons.person),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {},
                          child: ListTile(
                            title: Text("My Orders"),
                            leading: Icon(Icons.shopping_cart),
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                ));
                          },
                          child: ListTile(
                            title: Text("Settings"),
                            leading: Icon(
                              Icons.settings,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {},
                          child: ListTile(
                            title: Text("About"),
                            leading: Icon(
                              Icons.help,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                              await firebaseAuth.signOut();
                              await googleSignIn.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => LoginPage()),
                                (r) => false);
                          },
                          child: ListTile(
                            title: Text("Logout"),
                            leading: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
          CustomActionBar(
            title: "Profile",
            hasBackArrrow: false,
          )
        ],
      ),
    );
  }
}
