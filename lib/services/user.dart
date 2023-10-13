import "package:cloud_firestore/cloud_firestore.dart";

class UserException implements Exception {
  final String message;

  const UserException(this.message);
}

enum CourseImpression {
  none,
  like,
  dislike,
}

class PlatformUser {
  final String uid;
  final String photoUrl;
  final String displayName;
  final Map<String, CourseImpression> courseImpressions;

  const PlatformUser({
    required this.uid,
    required this.photoUrl,
    required this.displayName,
    required this.courseImpressions,
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
      photoUrl: data!["photoUrl"] ?? "",
      displayName: data["displayName"] ?? "",
      courseImpressions: Map<String, CourseImpression>.from(
        data["courseImpressions"] ?? {},
      ),
    );
  }

  Future<void> updateCourseImpression(
    String courseId,
    CourseImpression impression,
  ) async {
    courseImpressions[courseId] = impression;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"courseImpressions": courseImpressions});
  }
}
