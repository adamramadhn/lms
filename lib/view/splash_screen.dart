import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/view/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.pushNamedAndRemoveUntil(context, LoginPage.route, (route) => false);
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
