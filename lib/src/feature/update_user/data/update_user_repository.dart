import 'package:test_template/src/feature/update_user/data/update_user_datasource.dart';

abstract interface class IUpdateUserRepository {
  Future<bool> updateUser({required String name, required String email});
}

final class UpdateUserRepository implements IUpdateUserRepository {
  UpdateUserRepository({required IUpdateUserDataSource updateUserDataSource})
    : _updateUserDataSource = updateUserDataSource;

  final IUpdateUserDataSource _updateUserDataSource;

  @override
  Future<bool> updateUser({required String name, required String email}) =>
      _updateUserDataSource.updateUser(name: name, email: email);
}
