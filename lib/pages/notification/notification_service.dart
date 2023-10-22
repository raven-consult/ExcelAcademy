// // push notification
// import 'package:firebase_messaging/firebase_messaging.dart';

// void pushNotification(Map data){
//   FirebaseMessaging messaging = FirebaseMessaging.instance;


//   final mes = RemoteMessage(
//     data: <String, String>{
//       'title': 'Notification Title',
//       'body': 'Notification Body',
//     },
//     to: data['token'], // The FCM token of the recipient device
//   );
// }

// // fetch notification

// //create notification dummy data