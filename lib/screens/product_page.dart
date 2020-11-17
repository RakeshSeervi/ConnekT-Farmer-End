import 'package:agri_com/constants.dart';
import 'package:agri_com/models/fruits.dart';
import 'package:agri_com/models/product.dart';
import 'package:agri_com/models/vegetables.dart';
import 'package:agri_com/services/firebase_services.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:agri_com/widgets/image_swipe.dart';
import 'package:agri_com/widgets/product_weight.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  User _user = FirebaseAuth.instance.currentUser;

  FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedProductSize;

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"Weight": _selectedProductSize});
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"Weight": _selectedProductSize});
  }

  final SnackBar _snackBar = SnackBar(
    content: Text("Product added to the cart"),
  );
  final SnackBar _snackBarSaved = SnackBar(
    content: Text("Product saved"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Product product = Product.fromSnapshot(snapshot.data);
                List productSizes;

                if (product.category == 'Fruits')
                  productSizes = Fruits[product.subCategory]['weighted']
                      ? Fruits[product.subCategory]['weights']
                      : [1];
                else
                  productSizes = Vegetables[product.subCategory]['weighted']
                      ? Vegetables[product.subCategory]['weights']
                      : [1];

                _selectedProductSize = productSizes[0].toString();

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: product.images,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        "${product.name}",
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\Rs ${product.price}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "${product.description}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Select Weight",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: productSizes,
                      onSelected: (weight) {
                        _selectedProductSize = weight;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBarSaved);
                            },
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  "assets/images/tab_saved.png",
                                ),
                                height: 22.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
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
            hasBackArrrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
