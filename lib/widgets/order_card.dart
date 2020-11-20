import 'package:agri_com/constants.dart';
import 'package:agri_com/models/order.dart';
import 'package:agri_com/widgets/collage_builder.dart';
import 'package:agri_com/widgets/order_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({this.order});

  @override
  Widget build(BuildContext context) {
    String date = order.orderDate.day.toString() +
        ' / ' +
        order.orderDate.month.toString() +
        ' / ' +
        order.orderDate.year.toString();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 16),
      child: Container(
        height: 175,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.black)),
        child: Row(
          children: [
            CollageBuilder(
                images:
                    order.products.map((product) => product.imageUrl).toList()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
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
                          color: Color(0xFFFF1E00),
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
                        Icon(LineAwesomeIcons.calendar),
                        SizedBox(
                          width: 8,
                        ),
                        Text(date),
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
    );
  }
}
