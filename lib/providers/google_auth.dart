import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart.dart';

class GoogleAuth with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();

  String? _accessToken;
  String? _idToken;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      _accessToken = googleAuth.accessToken;
      _idToken = googleAuth.idToken;
      final prefs = await SharedPreferences.getInstance();
      final userToken = json.encode({
        'accessToken': _accessToken,
        'idToken': _idToken,
      });
      prefs.setString('userToken', userToken);

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = await FirebaseAuth.instance.currentUser;
      String? firebaseIdToken = await user?.getIdToken(true);
      while (firebaseIdToken!.length > 0) {
        int startTokenLength = (firebaseIdToken.length >= 500 ? 500 : firebaseIdToken.length);
        print("Firebase Token: " + firebaseIdToken.substring(0, startTokenLength));
        int lastTokenLength = firebaseIdToken.length;
        firebaseIdToken =
            firebaseIdToken.substring(startTokenLength, lastTokenLength);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      _idToken = null;
      _accessToken = null;
      await _googleSignIn.signOut();
      FirebaseAuth.instance.signOut();
      Cart cart = new Cart();
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
