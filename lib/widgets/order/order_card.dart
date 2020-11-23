import 'package:agri_com/constants.dart';
import 'package:agri_com/models/order.dart';
import 'package:agri_com/screens/order_details.dart';
import 'package:agri_com/services/miscellaneous.dart';
import 'package:agri_com/widgets/order/collage_builder.dart';
import 'package:agri_com/widgets/order/order_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetails(
                        order: order,
                      )));
        },
        child: Container(
          height: 175,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.black)),
          child: Row(
            children: [
              CollageBuilder(
                  images: order.products
                      .map((product) => product.imageUrl)
                      .toList()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                order.buyerName,
                                style: Constants.regularHeading,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.shopping_bag,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: OrderSummary(
                              names: order.products
                                  .map((product) => product.name)
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.calendar,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(Utilities.getDate(order.orderDate)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.indian_rupee_sign,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            order.amount.toString(),
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
