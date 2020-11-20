import 'package:agri_com/models/product.dart';
import 'package:agri_com/screens/product_form.dart';
import 'package:agri_com/screens/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProductGrid extends StatelessWidget {
  final Product product;

  ProductGrid({this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: product != null
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      product: product,
                    ),
                  ));
            }
          : () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProductForm()));
            },
      child: Container(
        alignment: Alignment.center,
        height: 175.0,
        child: Stack(
          children: [
            Container(
              height: 175.0,
              width: 175,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: product != null
                    ? Image.network(
                  product.images[0],
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/add.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        product != null ? product.name : '',
                        style: Constants.regularHeading,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        product != null ? 'Rs ' + product.price.toString() : '',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme
                                .of(context)
                                .accentColor,
                            fontWeight: FontWeight.w600),
                      ),
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
