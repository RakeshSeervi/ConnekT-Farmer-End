import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Uuid _uuid = Uuid();

  static const String IMAGES = 'images';
  static const String NAME = 'name';
  static const String DESCRIPTION = 'description';
  static const String PRICE = 'price';
  static const String CATEGORY = 'category';
  static const String SUB_CATEGORY = 'sub-category';
  static const String SELLER_NAME = 'seller-name';
  static const String SELLER_ID = 'seller-id';

  static Future<bool> addProduct(Map data) async {
    List<String> downloadableUrls = [];
    List images = data[IMAGES];

    for (int i = 0; i < images.length; i++) {
      String url = await getDownloadableUrl(images[i]);
      downloadableUrls.add(url);
    }

    if (downloadableUrls.length < 1) return false;

    return await _firestore.collection('Products').add({
      NAME: data[NAME],
      PRICE: data[PRICE],
      IMAGES: downloadableUrls,
      DESCRIPTION: data[DESCRIPTION],
      CATEGORY: data[CATEGORY],
      SUB_CATEGORY: data[SUB_CATEGORY],
      SELLER_ID: _auth.currentUser.uid,
      SELLER_NAME: _auth.currentUser.displayName,
    }).then((value) => value != null);
  }

  static Future<String> getDownloadableUrl(image) async {
    StorageTaskSnapshot snapshot = await _storage
        .ref()
        .child("images/${_uuid.v1()}")
        .putFile(image)
        .onComplete;
    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    }
    return null;
  }
}
