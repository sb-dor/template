import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/features/authentication/models/user.dart';
import 'package:test_template/src/features/initialization/logic/dependency_composition/factories/factory.dart';
import 'package:test_template/src/features/update_user/bloc/update_user_bloc.dart';
import 'package:test_template/src/features/update_user/data/update_user_datasource.dart';
import 'package:test_template/src/features/update_user/data/update_user_repository.dart';

final class UpdateUserBlocFactory extends Factory<UpdateUserBloc> {
  UpdateUserBlocFactory({required this.user, required this.logger, required this.restClientBase});

  final User user;
  final Logger logger;
  final RestClientBase restClientBase;

  @override
  UpdateUserBloc create() {
    final IUpdateUserDataSource updateUserDataSource = UpdateUserDataSource(
      logger: logger,
      restClientBase: restClientBase,
    );

    final IUpdateUserRepository updateUserRepository = UpdateUserRepository(
      updateUserDataSource: updateUserDataSource,
    );

    return UpdateUserBloc(
      updateUserRepository: updateUserRepository,
      initialState: UpdateUserState.initial(user),
    );
  }
}
