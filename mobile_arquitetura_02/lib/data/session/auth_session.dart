import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_01/domain/entities/user.dart';

class AuthSession extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
