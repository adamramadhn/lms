import 'dart:convert';

import 'package:lms/models/user_by_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static String userData = "data_user";

  Future<SharedPreferences> sharePref() async {
    final sharePref = await SharedPreferences.getInstance();
    return sharePref;
  }

  Future _saveString(key, data) async {
    final pref = await sharePref();
    await pref.setString(key, data);
  }

  Future<String?> _getString(key) async {
    final pref = await sharePref();
    return pref.getString(key);
  }

  setUserData(UserData userDataModel) async {
    final json = userDataModel.toJson();
    final userDataString = jsonEncode(json);
    await _saveString(userData, userDataString);
  }

  Future<UserData?> getUserData() async {
    final user = await _getString(userData);
    final jsonUserData = jsonDecode(user!);
    final userDataModel = UserData.fromJson(jsonUserData);
    return userDataModel;
  }
}
