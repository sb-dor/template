import 'package:logger/logger.dart';
import 'package:test_template/src/feature/authentication/data/datasource/authentication_datasource.dart';
import 'package:test_template/src/feature/authentication/models/user.dart';

final class AuthenticationLocalDatasource implements IAuthenticationDataSource {
  AuthenticationLocalDatasource({required this.logger});

  final Logger logger;

  @override
  Future<User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<User?> signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
