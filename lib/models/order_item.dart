import 'fruits.dart';
import 'vegetables.dart';

class OrderItem {
  static const String NAME = 'name';
  static const String PRICE = 'price';
  static const String IMAGE = 'image';
  static const String QUANTITIES = 'quantities';
  static const String CATEGORY = 'category';
  static const String SUB_CATEGORY = 'sub-category';

  String _name;
  int _price;
  String _imageUrl;
  List<int> _quantities;
  List<double> _weights;

  String get name => _name;

  int get price => _price;

  String get imageUrl => _imageUrl;

  List<int> get quantities => _quantities;

  List<double> get weights => _weights;

  OrderItem.fromMap(Map productDetails) {
    this._name = productDetails[NAME];
    this._price = productDetails[PRICE];
    this._imageUrl = productDetails[IMAGE];
    this._quantities = productDetails[QUANTITIES].cast<int>();
    this._weights = productDetails[CATEGORY] == 'Fruits'
        ? Fruits[productDetails[SUB_CATEGORY]]['weights']
        : Vegetables[productDetails[SUB_CATEGORY]]['weights'];
  }
}
