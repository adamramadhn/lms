import 'package:flutter/material.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/helper/user_email.dart';
import 'package:lms/models/network_response.dart';
import 'package:lms/models/user_by_email.dart';
import 'package:lms/repository/auth_api.dart';
import 'package:lms/view/login_page.dart';

import '../../../helper/preference_helper.dart';
import '../../main_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static String route = "edit_profile_page";

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

enum Gender { lakilaki, perempuan }

class _EditProfilePageState extends State<EditProfilePage> {
  List<String> classSlta = ["10", "11", "12"];

  String gender = "Laki-Laki";
  String selectedClass = "10";
  final emailController = TextEditingController();
  final schoolNameController = TextEditingController();
  final fullNameController = TextEditingController();

  onTapGender(Gender genderInput) {
    if (genderInput == Gender.lakilaki) {
      gender = "Laki-Laki";
    } else {
      gender = "Perempuan";
    }
    setState(() {});
  }

  initDataUser() async {
    emailController.text = UserEmail.getUserEmail()!;
    final dataUser = await PreferenceHelper().getUserData();
    fullNameController.text = dataUser!.userName!;
    schoolNameController.text = dataUser.userAsalSekolah!;
    gender = dataUser.userGender!;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(25),
        //     bottomRight: Radius.circular(25),
        //   ),
        // ),
        elevation: 0,
        backgroundColor: R.colors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Akun",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ButtonLogin(
            radius: 8,
            backgroundCOlor: R.colors.primary,
            borderColor: R.colors.primary,
            onTap: () async {
              final json = {
                "email": emailController.text,
                "nama_lengkap": fullNameController.text,
                "nama_sekolah": schoolNameController.text,
                "kelas": selectedClass,
                "gender": gender,
                "foto": UserEmail.getUserPhotoUrl(),
              };
              // print(json);
              final result = await AuthApi().postRegister(json);
              if (result.status == Status.success) {
                final registerResult =
                    UserByEmailResponse.fromJson(result.data!);
                if (registerResult.status == 1) {
                  await PreferenceHelper().setUserData(registerResult.data!);
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainPage.route, (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(registerResult.message!),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Terjadi Kesalahan, Silahkan ulangi kembali!"),
                  ),
                );
              }
            },
            child: Text(
              R.strings.perbaharuiAkun,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileTextField(
                title: 'Email',
                hintText: 'Email Anda',
                controller: emailController,
                enable: false,
              ),
              EditProfileTextField(
                title: 'Nama Lengkap',
                hintText: 'Nama Lengkap Anda',
                controller: fullNameController,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: R.colors.greySubtitle),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: gender == "Laki-Laki"
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                width: 1, color: R.colors.greyBorder),
                          ),
                        ),
                        child: Text(
                          "Laki-Laki",
                          style: TextStyle(
                              fontSize: 14,
                              color: gender == "Laki-Laki"
                                  ? Colors.white
                                  : const Color(0xff282828)),
                        ),
                        onPressed: () {
                          onTapGender(Gender.lakilaki);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: gender == "Perempuan"
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                width: 1, color: R.colors.greyBorder),
                          ),
                        ),
                        child: Text(
                          "Perempuan",
                          style: TextStyle(
                              fontSize: 14,
                              color: gender == "Perempuan"
                                  ? Colors.white
                                  : const Color(0xff282828)),
                        ),
                        onPressed: () {
                          onTapGender(Gender.perempuan);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Kelas",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: R.colors.greySubtitle),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: R.colors.greyBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedClass,
                    items: classSlta
                        .map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (String? val) {
                      selectedClass = val!;
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              EditProfileTextField(
                title: "Nama Sekolah",
                hintText: "Nama Sekolah",
                controller: schoolNameController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField(
      {Key? key,
      required this.title,
      required this.hintText,
      this.controller,
      this.enable = true})
      : super(key: key);
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: R.colors.greySubtitle),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            enabled: enable,
            controller: controller,
            decoration: InputDecoration(
              // border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: R.colors.greyHintText),
            ),
          ),
        ],
      ),
    );
  }
}
