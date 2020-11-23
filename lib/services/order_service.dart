import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> dispatch(String orderId) {
    return _firestore
        .collection('Orders')
        .doc(orderId)
        .update({'packed': true, 'packed-date': Timestamp.now()})
        .then((value) => true)
        .catchError((e) => false);
  }
}
