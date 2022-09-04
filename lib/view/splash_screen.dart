import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/helper/user_email.dart';
import 'package:lms/models/network_response.dart';
import 'package:lms/view/login_page.dart';
import 'package:lms/view/main_page.dart';

import '../helper/preference_helper.dart';
import '../models/user_by_email.dart';
import '../repository/auth_api.dart';
import 'register_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () async {
        final user = UserEmail.getUserEmail();
        if (user != null) {
          final dataUser = await AuthApi().getUserByEmail();
          if (dataUser.status == Status.success) {
            final data = UserByEmailResponse.fromJson(dataUser.data!);
            if (data.status == 1) {
              await PreferenceHelper().setUserData(data.data!);
              Navigator.pushNamedAndRemoveUntil(
                  context, MainPage.route, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, RegisterPage.route, (route) => false);
            }
          }
        } else {
          Navigator.pushReplacementNamed(context, LoginPage.route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
