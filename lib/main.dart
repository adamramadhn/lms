import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/view/login_page.dart';
import 'package:lms/view/main/discuss/chat_page.dart';
import 'package:lms/view/main/latihan_soal/mapel_page.dart';
import 'package:lms/view/main/latihan_soal/paket_soal_page.dart';
import 'package:lms/view/main/profile/profile_page.dart';
import 'package:lms/view/main_page.dart';
import 'package:lms/view/register_page.dart';
import 'package:lms/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Soal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: R.colors.primary),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        LoginPage.route: (context) => const LoginPage(),
        RegisterPage.route: (context) => const RegisterPage(),
        MainPage.route: (context) => const MainPage(),
        ChatPage.route: (context) => const ChatPage(),
        MapelPage.route: (context) => const MapelPage(),
        PaketSoalPage.route: (context) => const PaketSoalPage(),
        ProfilePage.route: (context) => const ProfilePage(),
      },
    );
  }
}
