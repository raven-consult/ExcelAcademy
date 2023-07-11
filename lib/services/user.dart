import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";

class UserException implements Exception {
  final String message;
  const UserException(this.message);
}

enum Gender {
  male,
  female,
}

class PlatformUser {
  final Enum gender;
  final String username;
  final DateTime dateOfBirth;
  final String profilePicture;

  const PlatformUser({
    required this.gender,
    required this.username,
    required this.dateOfBirth,
    required this.profilePicture,
  });

  static fromMap(Map<String, dynamic> data) {
    return PlatformUser(
      username: data["username"],
      dateOfBirth: data["dateOfBirth"],
      gender: Gender.values[data["gender"]],
      profilePicture: data["profilePicture"],
    );
  }
}

class UserService {
  late String _uid;
  final String _collectionId = "users";
  late CollectionReference _collectionReference;
  final FirebaseFirestore _client = FirebaseFirestore.instance;

  UserService(String uid) {
    _uid = uid;
    _collectionReference = _client.collection(_collectionId);
  }

  Future<PlatformUser> getUserData() async {
    final doc = await _collectionReference.doc(_uid).get();
    if (!doc.exists) {
      throw const UserException("User does not exist");
    }
    var data = doc.data() as Map<String, dynamic>?;
    return PlatformUser.fromMap(data!);
  }

  Future<void> updateUserData({
    Gender? gender,
    String? username,
    DateTime? dateOfBirth,
    String? profilePicture,
  }) async {
    try {
      final doc = _collectionReference.doc(_uid);
      var prevData = (await doc.get()).data() as Map<String, dynamic>?;
      if (prevData == null) {
        throw const UserException("User does not exist");
      }
      var data = {
        "gender": gender ?? prevData["gender"],
        "username": username ?? prevData["username"],
        "dateOfBirth": dateOfBirth ?? prevData["dateOfBirth"],
        "profilePicture": profilePicture ?? prevData["profilePicture"],
      };
      await doc.update(data);
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
    }
  }
}
