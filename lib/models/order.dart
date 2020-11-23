import 'package:agri_com/models/order_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  static const String BUYER_ID = 'buyer-id';
  static const String BUYER_NAME = 'buyer-name';
  static const String SELLER_ID = 'seller-id';
  static const String SELLER_NAME = 'seller-name';
  static const String PRODUCTS = 'products';
  static const String AMOUNT = 'amount';
  static const String ORDER_DATE = 'order-date';
  static const String PACKED = 'packed';
  static const String PACKED_DATE = 'packed-date';

  String _id;
  String _buyerId;
  String _buyerName;
  String _sellerId;
  String _sellerName;
  List<OrderItem> _products = [];
  int _amount;
  Timestamp _orderDate;
  bool _packed;
  Timestamp _packedDate;

  List _rawProducts;

  String get id => _id;

  String get buyerId => _buyerId;

  String get buyerName => _buyerName;

  String get sellerId => _sellerId;

  String get sellerName => _sellerName;

  List<OrderItem> get products => _products;

  int get amount => _amount;

  DateTime get orderDate => _orderDate.toDate();

  bool get packed => _packed;

  DateTime get packedDate => _packedDate.toDate();

  Order.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.id;
    _buyerId = snapshot.data()[BUYER_ID];
    _buyerName = snapshot.data()[BUYER_NAME];
    _sellerId = snapshot.data()[SELLER_ID];
    _sellerName = snapshot.data()[SELLER_NAME];
    _amount = snapshot.data()[AMOUNT];
    _orderDate = snapshot.data()[ORDER_DATE];
    _packed = snapshot.data()[PACKED];
    _packedDate = snapshot.data()[PACKED_DATE];
    _rawProducts = snapshot.data()[PRODUCTS];

    _rawProducts.forEach((productMap) {
      _products.add(OrderItem.fromMap(productMap));
    });
  }
}
