import 'package:agri_com/models/product.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:agri_com/widgets/product_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoreTab extends StatefulWidget {
  @override
  _StoreTabState createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          StreamBuilder(
            initialData: null,
            stream: _productsRef
                .where("seller-id", isEqualTo: user.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ],
                );

              if (snapshot.connectionState == ConnectionState.none)
                return Center(
                  child: Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 60,
                  ),
                );

              if (snapshot.connectionState == ConnectionState.waiting)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: const CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(),
                    )
                  ],
                );

              return CustomisedView(
                productSnapshots: snapshot.data.docs,
              );
            },
          ),
          CustomActionBar(
            title: 'My Store',
          ),
        ],
      ),
    );
  }
}

class CustomisedView extends StatelessWidget {
  final List<QueryDocumentSnapshot> productSnapshots;

  CustomisedView({this.productSnapshots});

  final List active = [];
  final List inactive = [];

  @override
  Widget build(BuildContext context) {
    productSnapshots.forEach((QueryDocumentSnapshot snapshot) {
      if (snapshot.data()['available'] == true) {
        active.add(Product.fromSnapshot(snapshot));
      } else
        inactive.add(Product.fromSnapshot(snapshot));
    });

    return ListView(
      padding: EdgeInsets.only(
        top: 108.0,
        bottom: 12.0,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            'Active',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.green),
          ),
        ),
        GridView.count(
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [ProductGrid()] +
                active.map((product) {
                  if (product != null)
                    return ProductGrid(
                      product: product,
                    );
                }).toList()),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            'Inactive',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
        inactive.length > 0
            ? GridView.count(
                padding: EdgeInsets.symmetric(vertical: 8),
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: inactive.map((product) {
                  if (product != null)
                    return ProductGrid(
                      product: product,
                    );
                }).toList(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text('No inactive products'),
              ),
      ],
    );
  }
}
