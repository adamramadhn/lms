import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/helper/preference_helper.dart';
import 'package:lms/models/user_by_email.dart';
import 'package:lms/view/login_page.dart';
import 'package:lms/view/main/profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static String route = "profile_page";
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? user;
  getUserData() async {
    final data = await PreferenceHelper().getUserData();
    user = data;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Akun Saya"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pushNamed(context, EditProfilePage.route);
            },
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 28, bottom: 60, right: 15, left: 15),
                  decoration: BoxDecoration(
                      color: R.colors.primary,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.userName!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              user!.userAsalSekolah!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        R.assets.imgProfile,
                        width: 50,
                        height: 50,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Identitas Diri",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Nama Lengkap",
                        style: TextStyle(
                            color: R.colors.greySubtitleHome, fontSize: 12),
                      ),
                      Text(
                        user!.userName!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            color: R.colors.greySubtitleHome, fontSize: 12),
                      ),
                      Text(
                        user!.userEmail!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Jenis Kelamin",
                        style: TextStyle(
                            color: R.colors.greySubtitleHome, fontSize: 12),
                      ),
                      Text(
                        user!.userGender!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Kelas",
                        style: TextStyle(
                            color: R.colors.greySubtitleHome, fontSize: 12),
                      ),
                      Text(
                        user!.kelas!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Sekolah",
                        style: TextStyle(
                            color: R.colors.greySubtitleHome, fontSize: 12),
                      ),
                      Text(
                        user!.userAsalSekolah!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await GoogleSignIn().signOut();
                    await FirebaseAuth.instance.signOut();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.route, (route) => false);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 13),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Keluar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
