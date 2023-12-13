import 'package:cloud_firestore/cloud_firestore.dart';

class Forum {
  final String title;
  final String about;
  final String category;
  final String certification;
  final String creator;
  final String image;
  final Timestamp date;

  Forum(
      {required this.category,
      required this.certification,
      required this.creator,
      required this.image,
      required this.date,
      required this.title,
      required this.about});

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
        title: json['title'] as String,
        about: json['about group'] as String,
        category: json['category'] as String,
        certification: json['certification'] as String,
        creator: json['creator'] as String,
        image: json['image'] as String,
        date: json['date'] as Timestamp);
  }
}

Future<Forum> fetchForum(String forumId) async {
  DocumentSnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('forum').doc(forumId).get();
  var data = querySnapshot.data();

  return Forum(
    about: data!['about group'],
    title: data['title'],
    category: data['category'],
    certification: data['certification'],
    creator: data['creator'],
    image: data['image'],
    date: data['date'],
  );
}
