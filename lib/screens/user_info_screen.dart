import 'package:flutter/material.dart';

class UserInfoScreen extends StatelessWidget {
  static const routeName = '/user_info';
  const UserInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(child: Text('User Info')),
    );
  }
}
