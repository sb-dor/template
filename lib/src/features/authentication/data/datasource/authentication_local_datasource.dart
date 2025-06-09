import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/database/database_helpers/users_database_helper.dart';
import 'package:test_template/src/features/authentication/data/datasource/authentication_datasource.dart';
import 'package:test_template/src/features/authentication/models/user.dart';

// datasources can have try-catch only that time when it's necessary
// otherwise it will be propagated to bloc -> blocObserver -> runZoneGuarded (if blocObserver does not propagate it further)

// more info about Error handling:
// https://lazebny.io/mastering-error-handling/
final class AuthenticationLocalDatasource implements IAuthenticationDataSource {
  AuthenticationLocalDatasource({required this.logger, required this.usersDatabaseHelper});

  final Logger logger;
  final UsersDatabaseHelper usersDatabaseHelper;

  @override
  Future<User?> getCurrentUser() => usersDatabaseHelper.getCurrentUser();

  @override
  Future<User?> signIn({required String email, required String password}) =>
      usersDatabaseHelper.signIn(email: email, password: password);

  @override
  Future<bool> signOut() => usersDatabaseHelper.signOut();
}
