import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_01/data/session/auth_session.dart';
import 'package:mobile_arquitetura_01/domain/repositories/auth_repository.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodel/auth_state.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;
  final AuthSession session;

  AuthState _state = const AuthState();
  AuthState get state => _state;

  AuthViewModel(this.repository, this.session);

  Future<bool> login(String username, String password) async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    try {
      final user = await repository.login(username, password);
      session.setUser(user);
      _state = _state.copyWith(isLoading: false, clearError: true);
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_state.error != null) {
      _state = _state.copyWith(clearError: true);
      notifyListeners();
    }
  }
}
