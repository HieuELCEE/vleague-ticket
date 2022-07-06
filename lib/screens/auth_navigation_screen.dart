import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './login_screen.dart';
import './tabs_screen.dart';

class AuthNavigationScreen extends StatelessWidget {
  const AuthNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapshot.hasData) {
            return TabsScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('An error has occurred!'));
          } else
            return LoginScreen();
        },
      ),
    );
  }
}
