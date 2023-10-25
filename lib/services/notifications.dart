import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/src/widgets/navigator.dart";
import "package:mobile/pages/home/router.dart";
import "package:mobile/pages/notification/notification.dart";

Future<void> initializeNotifications() async {
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // TODO: The user should still be able to receive notifications
    return;
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    navigatorKey.currentState?.push(notificationUi() as Route<Object?>);
  }

//enable push  notification for ios
  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

//push notification on all state of the app (terminated, background)
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  final _firebaseMessaging = FirebaseMessaging.instance;
  await _firebaseMessaging.requestPermission();
  var token = await _firebaseMessaging.getToken();
  print({'token': token});
  if (token != null) {
    await NotificationService.setMyFCMToken(user.uid, token);
  }
  initPushNotification();

  _firebaseMessaging.onTokenRefresh.listen((token) async {
    await NotificationService.setMyFCMToken(user.uid, token);
  });
}

class NotificationService {
  static const String userCollection = "users";
  static const String notificationsCollection = "notifications";
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  const NotificationService._();

  static Future<Notifications> getMyNotifications(String uid) async {
    var res = await _firestore
        .collection(userCollection)
        .doc(uid)
        .collection(notificationsCollection)
        .get();

    return res.docs.map((snapshot) => Notification.fromMap(snapshot.data()));
  }

  static Future<void> setMyFCMToken(String uid, String token) async {
    await _firestore
        .collection(userCollection)
        .doc(uid)
        .update({"fcmToken": token});
  }
}

typedef Notifications = Iterable<Notification>;

const nAccount = "account";
const nActivity = "activity";
const nWhatsNew = "whatsNew";

class NotificationUser {
  final String uid;
  final String fcmToken;

  const NotificationUser({
    required this.uid,
    required this.fcmToken,
  });

  factory NotificationUser.fromMap(Map<String, dynamic> data) {
    return NotificationUser(
      uid: data["uid"],
      fcmToken: data["fcmToken"],
    );
  }
}

class Notification {
  final String type;
  final String body;
  final String title;
  final String thumbnailUrl;
  final DateTime datePublished;

  const Notification({
    required this.body,
    required this.title,
    this.type = nActivity,
    required this.thumbnailUrl,
    required this.datePublished,
  });

  factory Notification.fromMap(Map<String, dynamic> data) {
    return Notification(
      body: data["body"],
      title: data["title"],
      thumbnailUrl: data["thumbnailUrl"],
      datePublished: data["datePublished"],
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {}
