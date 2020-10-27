import 'package:agri_com/screens/settings_page.dart';
import 'package:agri_com/tabs/profile_tab.dart';
import 'package:agri_com/screens/myAccount_page.dart';
import 'package:agri_com/screens/login_page.dart';
import 'package:agri_com/screens/product_page.dart';
import 'package:agri_com/services/firebase_services.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final CollectionReference _userDetails =
      FirebaseFirestore.instance.collection('name');

  FirebaseServices _firebaseServices = FirebaseServices();

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
                          Container(
                            child: new UserAccountsDrawerHeader(
                              accountName: Text(
                                  "${document.data()['username']}" ??
                                      "Username"),
                              accountEmail: Text(
                                  "${document.data()['email']}" ?? "Email"),
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
                                            "${document
                                                .data()['profilePicture']}" ??
                                                "ProfilePicture",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              decoration: new BoxDecoration(
                                  color: Colors.blueAccent),
                            ),
                          ),
                          Container(
                            child: InkWell(
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
                              onTap: () {

                              },
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
                            child: InkWell(
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
                            child: InkWell(
                              onTap: () async
                              {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => LoginPage()),
                                        (r) => false);
                              },
                              child: ListTile(
                                title: Text("Logout"),
                                leading: Icon(
                                  Icons.cancel,
                                  color: Colors.green,
                                ),
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
          CustomActionBar(
            title: "Profile",
            hasBackArrrow: false,
            hasProfile: false,
            hasSaved: true,
          )
        ],
      ),
    );
  }
}
