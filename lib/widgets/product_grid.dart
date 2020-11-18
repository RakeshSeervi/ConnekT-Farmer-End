import 'package:agri_com/screens/product_form.dart';
import 'package:agri_com/screens/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProductGrid extends StatelessWidget {
  final String productId;
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String price;

  ProductGrid({this.onPressed, this.imageUrl, this.title, this.price, this.productId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: productId != null
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      productId: productId,
                    ),
                  ));
            }
          : () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProductForm()));
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: 175.0,
        margin: EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 12.0,
        ),
        child: Stack(
          children: [
            Container(
              height: 175.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl ?? Constants.addImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      title ?? '',
                      style: Constants.regularHeading,
                    ),
                    Text(
                      price ?? '',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme
                              .of(context)
                              .accentColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
