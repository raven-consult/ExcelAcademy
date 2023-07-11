import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final String _userId;

  final String _collectionId = "cart";
  final String _userCollectionId = "users";
  final FirebaseFirestore _client = FirebaseFirestore.instance;

  CartService(this._userId);

  Future<void> addToCart(CartItem item) async {
    var userRef = _client.collection(_userCollectionId).doc(_userId);
    var cartRef = userRef.collection(_collectionId);

    await cartRef.doc(item.id).set({
      "id": item.id,
    }, SetOptions(merge: true));
  }

  Future<void> removeFromCart(CartItem item) async {
    var userRef = _client.collection(_userCollectionId).doc(_userId);
    var cartRef = userRef.collection(_collectionId);

    await cartRef.doc(item.id).delete();
  }

  Future<List<CartItem>> getCartItems() async {
    var userRef = _client.collection(_userCollectionId).doc(_userId);
    var cartRef = userRef.collection(_collectionId);

    var snapshot = await cartRef.get();

    return snapshot.docs.map((e) => CartItem.fromMap(e.data())).toList();
  }
}

class CartItem {
  final String id;

  const CartItem({
    required this.id,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map["id"],
    );
  }
}
