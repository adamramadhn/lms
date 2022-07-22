import 'package:flutter/material.dart';
import 'package:lms/view/login_page.dart';
import 'package:lms/view/main/discuss/chat_page.dart';
import 'package:lms/view/main_page.dart';
import 'package:lms/view/register_page.dart';
import 'package:lms/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/regis': (context) => const RegisterPage(),
        '/main': (context) => const MainPage(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}
