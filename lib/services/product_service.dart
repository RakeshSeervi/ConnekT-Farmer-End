import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Uuid _uuid = Uuid();

  static const String productsRef = 'Products';

  static const String IMAGES = 'images';
  static const String NAME = 'name';
  static const String DESCRIPTION = 'description';
  static const String PRICE = 'price';
  static const String CATEGORY = 'category';
  static const String SUB_CATEGORY = 'sub-category';
  static const String SELLER_NAME = 'seller-name';
  static const String SELLER_ID = 'seller-id';
  static const String AVAILABLE = 'available';

  static Future<bool> addProduct(Map data) async {
    List downloadableUrls = [];
    List images = data[IMAGES];

    for (int i = 0; i < images.length; i++) {
      String url = await getDownloadableUrl(images[i]);
      downloadableUrls.add(url);
    }

    if (downloadableUrls.length < images.length) return false;

    return await _firestore
        .collection(productsRef)
        .add({
          NAME: data[NAME],
          PRICE: data[PRICE],
          IMAGES: downloadableUrls,
          DESCRIPTION: data[DESCRIPTION],
          CATEGORY: data[CATEGORY],
          SUB_CATEGORY: data[SUB_CATEGORY],
          SELLER_ID: _auth.currentUser.uid,
          SELLER_NAME: _auth.currentUser.displayName,
          AVAILABLE: true,
        })
        .then((value) => true)
        .catchError((error) {
          return false;
        });
  }

  static Future getDownloadableUrl(image) async {
    StorageTaskSnapshot snapshot = await _storage
        .ref()
        .child("images/${_uuid.v1()}")
        .putFile(image)
        .onComplete;
    if (snapshot.error == null) {
      return snapshot.ref.getDownloadURL();
    }
    return null;
  }

  static Future<bool> updateAvailability(productId, val) {
    return _firestore
        .collection(productsRef)
        .doc(productId)
        .update({AVAILABLE: val})
        .then((value) => true)
        .catchError((e) => false);
  }

  static Future<DocumentSnapshot> getProductById(String id) {
    return _firestore.collection(productsRef).doc(id).get();
  }
}
