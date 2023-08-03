import "package:cloud_firestore/cloud_firestore.dart";

class Course {
  final String id;
  final String title;
  final String description;

  Duration get duration {
    var total = 0;
    for (var video in videos) {
      total += video.duration;
    }
    return Duration(seconds: total);
  }

  final List<Video> videos;

  const Course({
    required this.id,
    required this.title,
    required this.videos,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "videos": List<dynamic>.from(videos.map((x) => x.toMap())),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      videos: List<Video>.from(map["videos"].map((x) => Video.fromMap(x))),
    );
  }

  @override
  String toString() {
    return "Course(id: $id, videos: $videos)";
  }
}

class CourseService {
  final CollectionReference collection;

  CourseService()
      : collection = FirebaseFirestore.instance.collection("courses");

  Future<Course> getCourseById(String courseId) async {
    var res = await collection.doc(courseId).get();
    if (!res.exists) {
      throw Exception("Course not found");
    }

    var data = res.data() as Map<String, dynamic>;

    return Course(
      id: res.id,
      title: data["title"],
      description: data["description"],
      videos: List<Video>.from(data["videos"].map((x) => Video.fromMap(x))),
    );
  }
}

class Video {
  final String id;
  final String title;
  final int duration;
  final String videoUrl;
  final String description;
  final String thumbnailUrl;

  const Video({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoUrl,
    required this.description,
    required this.thumbnailUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "duration": duration,
      "videoUrl": videoUrl,
      "description": description,
      "thumbnailUrl": thumbnailUrl,
    };
  }

  @override
  String toString() {
    return "Video(id: $id,"
        "title: $title, "
        "duration: $duration, "
        "videoUrl: $videoUrl, "
        "description: $description, "
        "thumbnailUrl: $thumbnailUrl)";
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map["id"],
      title: map["title"],
      duration: map["duration"],
      videoUrl: map["videoUrl"],
      description: map["description"],
      thumbnailUrl: map["thumbnailUrl"],
    );
  }
}
