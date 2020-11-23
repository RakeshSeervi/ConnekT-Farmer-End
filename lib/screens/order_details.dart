import 'package:agri_com/constants.dart';
import 'package:agri_com/models/order.dart';
import 'package:agri_com/models/order_item.dart';
import 'package:agri_com/services/miscellaneous.dart';
import 'package:agri_com/services/order_service.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:agri_com/widgets/order/order_product.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final Order order;

  OrderDetails({this.order});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool _dispatched;

  @override
  void initState() {
    _dispatched = widget.order.packed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: 108, bottom: 16, left: 16, right: 16),
            children: [
              for (OrderItem orderItem in widget.order.products)
                OrderProduct(
                  orderItem: orderItem,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total items'),
                          Text(
                            widget.order.products.length.toString(),
                            style: Constants.regularDarkText,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total amount'),
                          Text(
                            'Rs ' + widget.order.amount.toString(),
                            style: Constants.regularDarkText,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        color: Color(0xFFFF1E00),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Order Id: ',
                                    ),
                                    Text(widget.order.id),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Order date: ',
                                    ),
                                    Text(Utilities.getDate(
                                        widget.order.orderDate)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          widget.order.packed
                              ? Flexible(
                                  child: Text(
                                  'Dispatched on ' +
                                      Utilities.getDate(
                                          widget.order.packedDate),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ))
                              : Expanded(
                                  child: ElevatedButton(
                                    onPressed: _dispatched
                                        ? null
                                        : () async {
                                            bool success =
                                                await OrderService.dispatch(
                                                    widget.order.id);
                                            setState(() {
                                              _dispatched = success;
                                            });
                                          },
                                    child: _dispatched
                                        ? Text(
                                            'Dispatched',
                                          )
                                        : Text('Dispatch'),
                                  ),
                                )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          CustomActionBar(
            title: 'Order details',
            hasBackArrrow: true,
          )
        ],
      ),
    );
  }
}
