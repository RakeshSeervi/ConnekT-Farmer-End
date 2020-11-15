import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  static const String NAME = 'name';
  static const String DESCRIPTION = 'desc';
  static const String IMAGES = 'images';
  static const String PRICE = 'price';
  static const String WEIGHT = 'weight';

  String _id = '';
  String _name = '';
  String _description = '';
  List _images = [];
  int _price = 0;
  List _weights = [];

  String get id => _id;

  String get name => _name;

  String get description => _description;

  List get images => _images;

  int get price => _price;

  List get weights => _weights;

  Product() {
    _images = [
      'https://firebasestorage.googleapis.com/v0/b/agri-com.appspot.com/o/add.png?alt=media&token=b72ff0c8-f3c5-4113-8d5c-0e2237972471'
    ];
  }

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.id;
    _name = snapshot.data()[NAME];
    _description = snapshot.data()[DESCRIPTION];
    _images = snapshot.data()[IMAGES];
    _price = snapshot.data()[PRICE];
    _weights = snapshot.data()[WEIGHT];
  }
}
