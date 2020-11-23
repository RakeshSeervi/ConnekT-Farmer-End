import 'package:agri_com/constants.dart';
import 'package:agri_com/models/order_item.dart';
import 'package:flutter/material.dart';

class OrderProduct extends StatelessWidget {
  final OrderItem orderItem;

  OrderProduct({this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderItem.name,
                    style: Constants.regularDarkText,
                  ),
                  Text(
                    'Rs ${orderItem.price} per ' +
                        (orderItem.isWeighted ? 'kg' : 'unit'),
                    style: Constants.regularDarkText,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              color: Color(0xFFFF1E00),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      orderItem.imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 72,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: orderItem.isWeighted
                          ? List<int>.generate(
                                  orderItem.quantities.length, (index) => index)
                              .map((i) {
                                if (orderItem.quantities[i] != 0)
                                  return Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            orderItem.weights[i] < 1
                                                ? '${(orderItem.weights[i] * 1000).toInt()} g'
                                                : '${orderItem.weights[i].toInt()} kg',
                                            textAlign: TextAlign.center,
                                          )),
                                      Expanded(
                                          child: Text(
                                              'x ${orderItem.quantities[i]}')),
                                      Expanded(
                                        child: Text(
                                          'Rs ${orderItem.price * orderItem.quantities[i] * orderItem.weights[i]}',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  );
                              })
                              .where((element) => element != null)
                              .toList()
                          : [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Text('1 unit'),
                                        Text(
                                          '( ${orderItem.weights[0] < 1 ? '${(orderItem.weights[0] * 1000).toInt()}g' : '${orderItem.weights[0].toInt()} kg'} - ${orderItem.weights[1] < 1 ? '${orderItem.weights[1] * 1000}g' : '${orderItem.weights[1].toInt()} kg'} )',
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child:
                                          Text('x ${orderItem.quantities[0]}')),
                                  Expanded(
                                    child: Text(
                                      'Rs ${orderItem.price * orderItem.quantities[0]}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              )
                            ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
