import 'package:drift/drift.dart';
import 'package:test_template/src/common/utils/database/app_database.dart';
import 'package:test_template/src/features/authentication/models/user.dart';

class UsersDatabaseHelper {
  UsersDatabaseHelper(this.appDatabase);

  final AppDatabase appDatabase;

  Future<User?> getCurrentUser() async {
    final data = await appDatabase.select(appDatabase.usersTable).getSingleOrNull();
    if (data == null) return null;
    return User.fromUserTable(data);
  }

  // About expressions˝
  // https://drift.simonbinder.eu/dart_api/expressions/?h=express#boolean-algebra
  Future<User?> signIn({required String email, required String password}) async {
    final searchForUser =
        await (appDatabase.select(appDatabase.usersTable)..where(
          (element) =>
              Expression.and([element.email.equals(email), element.password.equals(password)]),
        )).getSingleOrNull();

    if (searchForUser != null) {
      return User.fromUserTable(searchForUser);
    }

    final newUserId = await appDatabase
        .into(appDatabase.usersTable)
        .insert(UsersTableCompanion.insert(email: email, password: password));

    final newUser =
        await (appDatabase.select(appDatabase.usersTable)
          ..where((user) => user.id.equals(newUserId))).getSingleOrNull();

    return newUser != null ? User.fromUserTable(newUser) : null;
  }

  Future<bool> signOut() async {
    final data = await appDatabase.select(appDatabase.usersTable).getSingleOrNull();
    if (data == null) return true;

    await appDatabase.delete(appDatabase.usersTable).go();

    return true;
  }
}
