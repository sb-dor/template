import 'package:test_template/src/feature/authentication/models/user.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/factories/factory.dart';
import 'package:test_template/src/feature/update_user/bloc/update_user_bloc.dart';
import 'package:test_template/src/feature/update_user/data/update_user_datasource.dart';
import 'package:test_template/src/feature/update_user/data/update_user_repository.dart';

final class UpdateUserBlocFactory extends Factory<UpdateUserBloc> {
  UpdateUserBlocFactory({required this.user});

  final User user;

  @override
  UpdateUserBloc create() {
    final IUpdateUserDataSource updateUserDataSource = UpdateUserDataSource();

    final IUpdateUserRepository updateUserRepository = UpdateUserRepository(
      updateUserDataSource: updateUserDataSource,
    );

    return UpdateUserBloc(
      updateUserRepository: updateUserRepository,
      initialState: UpdateUserState.initial(user),
    );
  }
}
