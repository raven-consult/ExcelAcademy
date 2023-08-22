import "package:cloud_firestore/cloud_firestore.dart";

class UserException implements Exception {
  final String message;

  const UserException(this.message);
}

class PlatformUser {
  final String uid;
  final String photoUrl;
  final String displayName;

  const PlatformUser({
    required this.uid,
    required this.photoUrl,
    required this.displayName,
  });

  static Future<PlatformUser> getUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (!doc.exists) {
      throw const UserException("User does not exist");
    }
    var data = doc.data();
    return PlatformUser(
      uid: uid,
      photoUrl: data!["photoUrl"],
      displayName: data["displayName"],
    );
  }
}
