import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

// push notification
class PushNotification {
  // final String url;

  // PushNotification(this.url);

  Future<void> push(Map data) async {
    try {
      final res = await http.post(
        Uri.parse('uri'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.JsonEncoder(data as Object? Function(dynamic object)?),
      );
    } catch (e) {
      print('$e');
    }
  }
}

// fetch notification

//create notification dummy data