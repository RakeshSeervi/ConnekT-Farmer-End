import 'package:agri_com/models/order.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:agri_com/widgets/order/order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  final CollectionReference _ordersRef =
      FirebaseFirestore.instance.collection("Orders");
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          StreamBuilder(
            initialData: null,
            stream:
                _ordersRef.where("seller-id", isEqualTo: user.uid).snapshots(),
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
                orderSnapshots: snapshot.data.docs,
              );
            },
          ),
          CustomActionBar(
            title: 'Orders',
          ),
        ],
      ),
    );
  }
}

class CustomisedView extends StatelessWidget {
  final List<QueryDocumentSnapshot> orderSnapshots;

  CustomisedView({this.orderSnapshots});

  final List pending = [];
  final List completed = [];

  @override
  Widget build(BuildContext context) {
    orderSnapshots.forEach((QueryDocumentSnapshot snapshot) {
      if (snapshot.data()['packed'] == false) {
        pending.add(Order.fromSnapshot(snapshot));
      } else
        completed.add(Order.fromSnapshot(snapshot));
    });

    return ListView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 108.0,
        bottom: 12.0,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Pending',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
        if (pending.length > 0)
          for (Order order in pending)
            OrderCard(
              order: order,
            )
        else
          Text('No orders pending!'),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Text(
            'Completed',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
        if (completed.length > 0)
          for (Order order in completed)
            OrderCard(
              order: order,
            )
        else
          Text('No orders to show!'),
      ],
    );
  }
}
