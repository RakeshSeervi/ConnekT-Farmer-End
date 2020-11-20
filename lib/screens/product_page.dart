import 'package:agri_com/constants.dart';
import 'package:agri_com/models/product.dart';
import 'package:agri_com/services/product_service.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:agri_com/widgets/image_swipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage({this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final SnackBar _snackBarDelete = SnackBar(
    content: Text("Product Deleted"),
  );
  final SnackBar _snackBarEdit = SnackBar(
    content: Text("Product Edited"),
  );

  bool isSwitched;

  @override
  void initState() {
    isSwitched = widget.product.available;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSwipe(
                imageList: widget.product.images,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.name,
                            style: Constants.boldHeading,
                          ),
                          Text(
                            "\Rs ${widget.product.price}",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Text(
                          "${widget.product.description}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Category ",
                                  style: Constants.regularHeading,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.product.category,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFF1E00)),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Subcategory ",
                                    style: Constants.regularHeading,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.product.subCategory,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF1E00)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "In stock",
                                  style: Constants.regularHeading,
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: FlutterSwitch(
                                    width: 64.0,
                                    height: 32.0,
                                    borderRadius: 8,
                                    padding: 4,
                                    valueFontSize: 16.0,
                                    toggleSize: 16.0,
                                    value: isSwitched,
                                    activeTextColor: Color(0xFFFF1E00),
                                    showOnOff: true,
                                    activeColor: Colors.black,
                                    onToggle: (val) async {
                                      bool success = await ProductService
                                          .updateAvailability(
                                              widget.product.id, val);
                                      if (success)
                                        setState(() {
                                          isSwitched = val;
                                        });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Edit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          CustomActionBar(
            hasBackArrrow: true,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
