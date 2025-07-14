import 'package:clone_tiktok/models/user_model.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:flutter/material.dart';

// in this project, we do not use Provider.
// this file is for demonstration purposes only.
class UserProvider with ChangeNotifier {
  UserModel? _user;
  final FirebaseMethods _authMethods = FirebaseMethods();

  UserModel? get user => _user;

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
