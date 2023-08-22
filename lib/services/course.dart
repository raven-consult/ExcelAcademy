import "package:cloud_firestore/cloud_firestore.dart";

class Course {
  final String id;
  final double price;
  final String title;
  final double rating;
  final String description;
  final String thumbnailUrl;
  final Iterable<Video> videos;
  final Iterable<Review> reviews;
  final Iterable<String> students;

  const Course({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.videos,
    required this.reviews,
    required this.students,
    required this.description,
    required this.thumbnailUrl,
  });

  Duration get duration {
    var total = 0;
    for (var video in videos) {
      total += video.duration;
    }
    return Duration(seconds: total);
  }

  static Future<Course> fromId(String id) async {
    var res =
        await FirebaseFirestore.instance.collection("courses").doc(id).get();

    if (!res.exists) {
      throw Exception("Course not found");
    }

    // Get the course data
    var data = res.data() as Map<String, dynamic>;

    return Course.fromMap(data);
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map["id"],
      title: map["title"],
      price: map["price"],
      rating: map["rating"],
      description: map["description"],
      thumbnailUrl: map["thumbnailUrl"],
      videos: (map["videos"] as List<dynamic>).map((e) => Video.fromMap(e)),
      students: (map["students"] as List<dynamic>).map((e) => e.toString()),
      reviews: (map["reviews"] as List<dynamic>).map((e) => Review.fromMap(e)),
    );
  }

  @override
  String toString() {
    return "Course(id: $id, "
        "title: $title, "
        "price: $price, "
        "rating: $rating, "
        "videos: $videos, "
        "reviews: $reviews, "
        "students: $students, "
        "description: $description, "
        "thumbnailUrl: $thumbnailUrl)";
  }
}

class Video {
  final String id;
  final String kind;
  final String title;
  final int duration;
  final String videoUrl;

  const Video({
    required this.id,
    required this.kind,
    required this.title,
    required this.duration,
    required this.videoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "duration": duration,
      "videoUrl": videoUrl,
    };
  }

  @override
  String toString() {
    return "Video(id: $id,"
        "kind: $kind,"
        "title: $title, "
        "duration: $duration, "
        "videoUrl: $videoUrl,)";
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map["id"],
      kind: map["kind"],
      title: map["title"],
      duration: map["duration"],
      videoUrl: map["videoUrl"],
    );
  }
}

class Review {
  final String id;
  final String user;
  final String body;
  final double rating;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.body,
    required this.user,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "body": body,
      "user": user,
      "rating": rating,
      "createdAt": createdAt,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map["id"],
      body: map["body"],
      user: map["user"],
      rating: map["rating"],
      createdAt: map["createdAt"],
    );
  }
}
