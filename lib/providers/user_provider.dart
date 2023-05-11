import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();

    _user = user;
    notifyListeners();
  }
}
