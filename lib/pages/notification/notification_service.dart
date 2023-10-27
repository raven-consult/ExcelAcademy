import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';

// push notification
class PushNotification {
  // final String url;

  // PushNotification(this.url);

  Future<void> push(
      {required String title,
      required String body,
      required String notif_type,
      String? token,
      String? topic}) async {
    try {
      final data = {
        'title': title,
        'body': body,
        'notif_type': notif_type,
        'token': token,
        'topic': topic
      };
      final res = await http.post(
        Uri.parse(
            'https://notification-service-gdw5iipadq-uc.a.run.app/push-notification/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      print(res.body);
    } catch (e) {
      print('$e');
    }
  }
}

// fetch notification

class getNotification {
  Future<List<QueryDocumentSnapshot>> gett() async {
    var user = FirebaseAuth.instance.currentUser;
    var id = user!.uid;

    try {
      final collectionReference = FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('notifications');
      final querySnapshot = await collectionReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        print(querySnapshot.docs);
        return querySnapshot.docs;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

//create notification dummy data

