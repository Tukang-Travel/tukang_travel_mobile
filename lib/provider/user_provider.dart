import 'package:flutter/material.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserService userService = UserService();
  UserModel? _user;
  UserModel get user => _user!;

  Future<void> refreshUser() async {
    UserModel user = await userService.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
