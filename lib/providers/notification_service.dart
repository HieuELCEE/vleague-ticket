import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService with ChangeNotifier {
  Future<void> sendNotification() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM TOKEN: $fcmToken');
    var url = Uri.parse('http://localhost:8081/api/v1/notification');
    var response = http.post(url,
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: jsonEncode(<String, dynamic>{
          "subject": "V-league Ticket Message",
          "token": '$fcmToken',
          "content":
              "Thank you.\nYour purchase was successful.\nPlease check your email to receive QR Ticket!"
        }));
  }

  Future<void> sendErrorNotification() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    var url = Uri.parse('http://localhost:8081/api/v1/notification');
    var response = http.post(url,
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: jsonEncode(<String, dynamic>{
          "subject": "V-league Ticket Message",
          "token": '$fcmToken',
          "content":
          "Payment cancel."
        }));
  }
}
