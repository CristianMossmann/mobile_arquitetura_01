import 'package:mobile_arquitetura_01/core/errors/failure.dart';
import 'package:mobile_arquitetura_01/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_arquitetura_01/domain/entities/user.dart';
import 'package:mobile_arquitetura_01/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String username, String password) async {
    try {
      return await remote.login(username, password);
    } on Exception catch (e) {
      throw Failure(e.toString().replaceFirst('Exception: ', ''));
    } catch (_) {
      throw Failure('Falha de conexão com o servidor');
    }
  }
}
