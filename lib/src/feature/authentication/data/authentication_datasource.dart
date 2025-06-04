import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/feature/authentication/models/user.dart';

abstract interface class IAuthenticationDataSource {
  Future<User?> signIn({required String email, required String password});

  Future<bool> signOut();

  Future<User?> getCurrentUser();
}

// datasources can have try-catch only that time when it's necessary
// otherwise it will be propagated to bloc -> blocObserver -> runZoneGuarded (if blocObserver does not propagate it further)
final class AuthenticationDataSource implements IAuthenticationDataSource {
  AuthenticationDataSource({required this.logger, required this.restClientBase});

  final Logger logger;

  // use for network requests
  final RestClientBase restClientBase;

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
