import 'package:test_template/src/feature/authentication/data/authentication_datasource.dart';
import 'package:test_template/src/feature/authentication/models/user.dart';

abstract interface class IAuthenticationRepository {
  Future<User?> signIn({required String email, required String password});

  Future<bool> signOut();

  Future<User?> getCurrentUser();
}

final class AuthenticationRepository implements IAuthenticationRepository {
  AuthenticationRepository({required IAuthenticationDataSource authenticationDataSource})
    : _authenticationDataSource = authenticationDataSource;

  final IAuthenticationDataSource _authenticationDataSource;

  @override
  Future<User?> getCurrentUser() => _authenticationDataSource.getCurrentUser();

  @override
  Future<User?> signIn({required String email, required String password}) =>
      _authenticationDataSource.signIn(email: email, password: password);

  @override
  Future<bool> signOut() => _authenticationDataSource.signOut();
}
