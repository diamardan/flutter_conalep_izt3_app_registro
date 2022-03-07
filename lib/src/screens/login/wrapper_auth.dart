import 'package:cetis32_app_registro/src/provider/user_provider.dart';
import 'package:cetis32_app_registro/src/screens/home/home_screen.dart';
import 'package:cetis32_app_registro/src/screens/login/login_navigator.dart';
import 'package:cetis32_app_registro/src/services/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final firebaseUser = Provider.of<User>(context);
    AuthenticationService _auth = AuthenticationService();

    if (firebaseUser != null) {
      if (!userProvider.isLoggingIn) userProvider.initUSer();
      return HomeScreen();
    } else {
      return LoginNavigator();
    }
  }
}
