import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static const String USERS = 'users';
  static const String PRODUCTS = 'products';
  static const String CATEGORIES = 'categories';
  static const String ORDERS = 'orders';
  static const String SETTINGS = 'settings';

  static Future<Map<String, dynamic>?> getSettings() async {
    final doc = await db.collection(SETTINGS).doc('app').get();
    return doc.data();
  }

  static Future<List<QueryDocumentSnapshot>> getProducts({
    String? categoryId,
    bool featured = false,
    int limit = 20,
  }) async {
    Query query = db.collection(PRODUCTS)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (categoryId != null) query = query.where('categoryId', isEqualTo: categoryId);
    if (featured) query = query.where('isFeatured', isEqualTo: true);
    final snapshot = await query.get();
    return snapshot.docs;
  }

  static Future<List<QueryDocumentSnapshot>> getCategories() async {
    final snapshot = await db.collection(CATEGORIES)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs;
  }

  static Future<List<QueryDocumentSnapshot>> getUserOrders(String userId) async {
    final snapshot = await db.collection(ORDERS)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs;
  }
}
