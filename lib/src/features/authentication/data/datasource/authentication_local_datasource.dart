import 'package:logger/logger.dart';
import 'package:test_template/src/features/authentication/data/datasource/authentication_datasource.dart';
import 'package:test_template/src/features/authentication/models/user.dart';

// datasources can have try-catch only that time when it's necessary
// otherwise it will be propagated to bloc -> blocObserver -> runZoneGuarded (if blocObserver does not propagate it further)

// more info about Error handling:
// https://lazebny.io/mastering-error-handling/
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
