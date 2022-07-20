import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class EmailService with ChangeNotifier {

  Future<void> sendEmail() async {
    final username = FirebaseAuth.instance.currentUser!.email;
    final url = Uri.parse('http://localhost:8081/api/v1/mail/$username');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print("Sending email successful");
    } else {
      print("Error sending email");
    }
  }
}