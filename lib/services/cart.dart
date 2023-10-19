import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mobile/services/user.dart';
import 'package:mobile/services/course.dart';

// CartItem is the course id
typedef CartItem = String;

class CartUser extends PlatformUser {
  final List<CartItem> cartItems;

  const CartUser(
      {required String uid,
      required this.cartItems,
      required String photoUrl,
      required String displayName,
      required Map<String, CourseImpression> courseImpressions})
      : super(
            uid: uid,
            photoUrl: photoUrl,
            displayName: displayName,
            courseImpressions: courseImpressions);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'photoUrl': photoUrl,
      'cartItems': cartItems,
      'displayName': displayName,
    };
  }

  static Future<CartUser> getUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (!doc.exists) {
      throw const UserException("User does not exist");
    }
    var data = doc.data();
    return CartUser(
        uid: uid,
        photoUrl: data!["photoUrl"] ?? "",
        displayName: data["displayName"] ?? "",
        cartItems: data["cartItems"] ?? [],
        courseImpressions: Map<String, CourseImpression>.from(
            data["courseImpressions"] ?? {}));
  }

  Future addToCart(CartItem item) async {
    cartItems.add(item);

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "cartItems": FieldValue.arrayUnion([item])
    });
  }

  Future<List<Course>> getCartItems() async {
    return Future.wait(cartItems.map((e) {
      return Course.fromId(e);
    }));
  }

  Future<void> clearCart() async {
    cartItems.clear();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"cartItems": FieldValue.delete()});
  }

  Future<void> removeFromCart(CartItem item) async {
    cartItems.remove(item);

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "cartItems": FieldValue.arrayRemove([item])
    });
  }
}
