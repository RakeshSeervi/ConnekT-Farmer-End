import 'package:agri_com/models/product.dart';
import 'package:agri_com/screens/product_form.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:agri_com/widgets/product_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreTab extends StatefulWidget {
  @override
  _StoreTabState createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
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
                List<Product> products = [Product()];

                snapshot.data.docs.forEach((productSnapshot) {
                  products.add(Product.fromSnapshot(productSnapshot));
                });
                // Display the data inside a list view
                return GridView.builder(
                  itemCount: products.length,
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return ProductGrid(
                      title: products[index].name,
                      imageUrl: products[index].images[0],
                      price: products[index].price != 0
                          ? "\$${products[index].price}"
                          : '',
                      productId: products[index].id,
                      onPressed: index == 0
                          ? () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductForm()));
                            }
                          : null,
                    );
                  },
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
            title: 'My Store',
            hasTitle: true,
            hasCart: false,
            hasSaved: false,
          ),
        ],
      ),
    );
  }
}
