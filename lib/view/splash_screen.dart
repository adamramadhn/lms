import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/view/login_page.dart';
import 'package:lms/view/main_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          //TODO redirect to register or home
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.route, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.route, (route) => false);
        }
      },
    );
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(
          R.assets.icSplash,
          height: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
