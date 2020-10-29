import 'package:agri_com/constants.dart';
import 'package:agri_com/screens/saved_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_com/screens/cart_page.dart';
import 'package:agri_com/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrrow;
  final bool hasTitle;
  final bool hasBackground;
  final bool hasCart;
  final bool hasSaved;

  CustomActionBar(
      {this.title,
      this.hasBackArrrow,
      this.hasTitle,
      this.hasBackground,
      this.hasCart,
      this.hasSaved});

  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  final User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasBackground = hasBackground ?? true;
    bool _hasCart = hasCart ?? true;
    bool _hasSaved = hasSaved ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: _hasBackground
              ? LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0),
            ],
            begin: Alignment(0, 0),
            end: Alignment(0, 1),
          ): null
      ),
      padding: EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          if(_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(
                      "assets/images/back_arrow.png"
                  ),
                  color: Colors.black,
                  width: 16.0,
                  height: 16.0,
                ),
              ),
            ),
          if(_hasTitle)
            Text(
              title ?? "Action Bar",
              style: Constants.boldHeading,
            ),
          if(_hasCart)
            GestureDetector(
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(
              //     builder: (context) => CartPage(),
              //   ));
              // },
              child: Row(
                children: [
                  if(_hasSaved)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SavedPage(),
                        ));
                      },
                      child: Container(
                        width: 42.0,
                        height: 42.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage(
                              "assets/images/heart.png"
                          ),
                          color: Colors.black,
                          width: 20.0,
                          height: 20.0,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ));
                    },
                    child: Container(
                      width: 42.0,
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      alignment: Alignment.centerRight,
                      child: Image(
                        image: AssetImage(
                            "assets/images/customer.png"
                        ),
                        color: Colors.black,
                        width: 16.0,
                        height: 16.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ));
                    },
                    child: Container(
                      width: 10.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,

                      child: StreamBuilder(

                        stream: _usersRef.doc(_firebaseServices.getUserId())
                            .collection("Cart")
                            .snapshots(),
                        builder: (context, snapshot) {
                          int _totalItems = 0;

                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            List _documents = snapshot.data.docs;
                            _totalItems = _documents.length;
                          }

                          return Text(
                            "$_totalItems" ?? "0",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}