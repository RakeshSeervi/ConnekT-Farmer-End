import 'package:cloud_firestore/cloud_firestore.dart';

import 'fruits.dart';
import 'vegetables.dart';

class Product {
  static const String NAME = 'name';
  static const String DESCRIPTION = 'description';
  static const String IMAGES = 'images';
  static const String PRICE = 'price';
  static const String CATEGORY = 'category';
  static const String SUB_CATEGORY = 'sub-category';
  static const String SELLER_NAME = 'seller-name';
  static const String SELLER_ID = 'seller-id';
  static const String AVAILABLE = 'available';

  String _id;
  String _name;
  String _description;
  List<String> _images;
  int _price;
  String _category;
  String _subCategory;
  bool _isWeighted;
  List<double> _weights;
  String _sellerName;
  String _sellerId;
  bool _available;

  String get id => _id;

  String get name => _name;

  String get description => _description;

  List<String> get images => _images;

  int get price => _price;

  String get category => _category;

  String get subCategory => _subCategory;

  bool get isWeighted => _isWeighted;

  List<double> get weights => _weights;

  String get sellerId => _sellerId;

  String get sellerName => _sellerName;

  bool get available => _available;

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.id;
    _name = snapshot.data()[NAME];
    _description = snapshot.data()[DESCRIPTION];
    _images = snapshot.data()[IMAGES].cast<String>();
    _price = snapshot.data()[PRICE];
    _category = snapshot.data()[CATEGORY];
    _subCategory = snapshot.data()[SUB_CATEGORY];
    if (_category == 'Fruits') {
      _isWeighted = Fruits[_subCategory]['weighted'];
      _weights = Fruits[_subCategory]['weights'];
    } else {
      _isWeighted = Vegetables[_subCategory]['weighted'];
      _weights = Vegetables[_subCategory]['weights'];
    }
    _sellerId = snapshot.data()[SELLER_ID];
    _sellerName = snapshot.data()[SELLER_NAME];
    _available = snapshot.data()[AVAILABLE];
  }
}
