import 'package:test_template/src/feature/authentication/models/user.dart';

abstract interface class IAuthenticationDataSource {
  Future<User?> signIn({required String email, required String password});

  Future<bool> signOut();

  Future<User?> getCurrentUser();
}

final class AuthenticationDataSource implements IAuthenticationDataSource {
  @override
  Future<User?> getCurrentUser() async {
    // Simulate a network call or database query
    await Future.delayed(const Duration(seconds: 1));
    return User(id: '123', email: 'test@example.com');
  }

  @override
  Future<User?> signIn({required String email, required String password}) async {
    // Simulate a network call or database query
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@example.com' && password == 'password') {
      return User(id: '123', email: 'test@example.com');
    }
    return null;
  }

  @override
  Future<bool> signOut() async {
    // Simulate a network call or database query
    await Future.delayed(const Duration(seconds: 1));
    return true; // Simulate successful sign-out
  }
}
