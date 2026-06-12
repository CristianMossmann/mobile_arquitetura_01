import 'package:mobile_arquitetura_01/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
}
