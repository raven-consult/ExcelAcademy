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
  Future<Map<String, List<NotificationModel>>> getNotifications() async {
    var user = FirebaseAuth.instance.currentUser;
    var id = user!.uid;
    // Create a reference to your Firestore collection.

    try {
      final collectionReference = FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('notifications');
      final activies = await collectionReference
          .where('notif_type', isEqualTo: 'activities')
          .orderBy('date', descending: true)
          .get();
      final account = await collectionReference
          .where('notif_type', isEqualTo: 'account')
          .orderBy('date', descending: true)
          .get();

      final news = await collectionReference
          .where('notif_type', isEqualTo: 'news')
          .orderBy('date', descending: true)
          .get();

      List<NotificationModel> notifications_activities = [];
      List<NotificationModel> notifications_account = [];
      List<NotificationModel> notifications_new = [];
      activies.docs.forEach((doc) {
        notifications_activities.add(NotificationModel(
            title: doc['title'],
            body: doc['body'],
            notif_type: doc['notif_type'],
            date: doc['date']));
      });

      account.docs.forEach((doc) {
        notifications_account.add(NotificationModel(
            title: doc['title'],
            body: doc['body'],
            notif_type: doc['notif_type'],
            date: doc['date']));
      });

      news.docs.forEach((doc) {
        notifications_new.add(NotificationModel(
            title: doc['title'],
            body: doc['body'],
            notif_type: doc['notif_type'],
            date: doc['date']));
      });

      Map<String, List<NotificationModel>> notificationMap = {
        "activities": notifications_activities,
        "account": notifications_account,
        "news": notifications_new
      };

      return notificationMap;
    } catch (e) {
      print('error');
      print(e);
      return {};
    }
  }
}

//Notification Model

class NotificationModel {
  String title;
  String body;
  String notif_type;
  Timestamp date;

  NotificationModel(
      {required this.title,
      required this.body,
      required this.notif_type,
      required this.date});
}
