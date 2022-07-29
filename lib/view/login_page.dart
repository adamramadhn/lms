import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/view/register_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String route = "login_page";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                R.strings.login,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(R.assets.imgLogin),
            const SizedBox(
              height: 35,
            ),
            Text(
              R.strings.welcome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            Text(
              R.strings.loginDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: R.colors.greySubtitle),
            ),
            const Spacer(),
            ButtonLogin(
              backgroundCOlor: Colors.white,
              borderColor: R.colors.primary,
              onTap: () async {
                await signInWithGoogle();

                final user = FirebaseAuth.instance.currentUser;
                if (mounted) {
                  if (user != null) {
                    Navigator.pushNamed(context, RegisterPage.route);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Gagal Masuk"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(R.assets.icGoogle),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    R.strings.loginWithGoogle,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: R.colors.blackLogin),
                  ),
                ],
              ),
            ),
            ButtonLogin(
              backgroundCOlor: Colors.black,
              borderColor: Colors.black,
              onTap: () => Navigator.pushNamed(context, RegisterPage.route),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(R.assets.icApple),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    R.strings.loginWithApple,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLogin extends StatelessWidget {
  const ButtonLogin(
      {Key? key,
      required this.backgroundCOlor,
      required this.child,
      required this.borderColor,
      required this.onTap})
      : super(key: key);
  final Color backgroundCOlor;
  final Widget child;
  final Color borderColor;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: backgroundCOlor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: borderColor),
            ),
            fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
          ),
          onPressed: onTap,
          child: child),
    );
  }
}
