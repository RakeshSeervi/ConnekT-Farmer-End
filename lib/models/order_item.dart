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
  bool _isWeighted;
  List<double> _weights;

  String get name => _name;

  int get price => _price;

  String get imageUrl => _imageUrl;

  List<int> get quantities => _quantities;

  bool get isWeighted => _isWeighted;

  List<double> get weights => _weights;

  OrderItem.fromMap(Map productDetails) {
    _name = productDetails[NAME];
    _price = productDetails[PRICE];
    _imageUrl = productDetails[IMAGE];
    _quantities = productDetails[QUANTITIES].cast<int>();
    if (productDetails[CATEGORY] == 'Fruits') {
      _isWeighted = Fruits[productDetails[SUB_CATEGORY]]['weighted'];
      _weights = Fruits[productDetails[SUB_CATEGORY]]['weights'];
    } else {
      _isWeighted = Vegetables[productDetails[SUB_CATEGORY]]['weighted'];
      _weights = Vegetables[productDetails[SUB_CATEGORY]]['weights'];
    }
  }
}
