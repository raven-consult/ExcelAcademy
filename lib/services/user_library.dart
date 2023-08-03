import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "course.dart";

enum CourseStatus {
  ongoing,
  completed,
  inBookmark,
}

class UserCourse {
  final String id;
  double progress;
  CourseStatus status;
  final Course course;
  final DateTime addedAt;
  final DateTime updatedAt;

  UserCourse({
    required this.id,
    required this.course,
    required this.status,
    required this.addedAt,
    required this.progress,
    required this.updatedAt,
  });

  void incrementProgress() {
    progress++;
  }

  void decrementProgress() {
    progress--;
  }

  @override
  String toString() {
    return "UserCourse("
        "id: $id,"
        "progress: $progress,"
        "status: $status, "
        "course: $course, "
        "addedAt: $addedAt, "
        "updatedAt: $updatedAt)";
  }

  void incrementStatus() {
    if (status == CourseStatus.inBookmark) {
      status = CourseStatus.ongoing;
    } else if (status == CourseStatus.ongoing) {
      status = CourseStatus.completed;
    } else if (status == CourseStatus.completed) {
      return;
    }
  }

  double getProgressPercentage() {
    return (progress / course.videos.length) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "progress": progress,
      "course": course.toMap(),
      "addedAt": addedAt,
      "updatedAt": updatedAt,
      "status": status.index,
    };
  }

  factory UserCourse.fromMap(Map<String, dynamic> map) {
    return UserCourse(
      id: map["id"],
      progress: map["progress"],
      course: Course.fromMap(map["course"]),
      addedAt: map["addedAt"],
      updatedAt: map["updatedAt"],
      status: CourseStatus.values[map["status"]],
    );
  }
}

class UserLibraryService {
  late final CollectionReference collection;

  UserLibraryService() {
    var currentUser = FirebaseAuth.instance.currentUser;
    collection = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .collection("library");
  }

  Future<UserCourse> addCourseToLibrary(
      Course course, CourseStatus courseStatus) async {
    var res = await collection.add({
      "progress": 0,
      "courseId": course.id,
      "status": courseStatus.index,
      "addedAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    return UserCourse(
      id: res.id,
      progress: 0,
      course: course,
      addedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: courseStatus,
    );
  }

  Future<void> removeCourseFromLibrary(String userCourseId) async {
    await collection.doc(userCourseId).delete();
  }

  Future<UserCourse> saveCourse(UserCourse userCourse) async {
    await collection.doc(userCourse.id).update({
      "progress": userCourse.progress,
      "courseId": userCourse.course.id,
      "status": userCourse.status.index,
      "updatedAt": FieldValue.serverTimestamp(),
    });

    return userCourse;
  }

  Future<UserCourse> getUserCourseByUserCourseId(String courseId) async {
    var res = await collection.where("courseId", isEqualTo: courseId).get();
    if (res.docs.isEmpty) {
      throw Exception("User course not found");
    }

    var doc = res.docs.first;

    var courseService = CourseService();
    var course = await courseService.getCourseById(doc["courseId"]);

    return UserCourse(
      id: doc.id,
      course: course,
      progress: doc["progress"],
      addedAt: doc["addedAt"].toDate(),
      updatedAt: doc["updatedAt"].toDate(),
      status: CourseStatus.values[doc["status"]],
    );
  }
}
