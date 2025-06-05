import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/features/authentication/data/authentication_repository.dart';
import 'package:test_template/src/features/authentication/models/user.dart';
import 'package:test_template/src/features/initialization/logic/dependency_composition/factories/factory.dart';
import 'package:test_template/src/features/update_user/bloc/update_user_bloc.dart';
import 'package:test_template/src/features/update_user/data/update_user_datasource.dart';
import 'package:test_template/src/features/update_user/data/update_user_repository.dart';

final class UpdateUserBlocFactory extends Factory<UpdateUserBloc> {
  UpdateUserBlocFactory({
    required this.user,
    required this.logger,
    required this.restClientBase,
    required this.authenticationRepository,
  });

  final User user;
  final Logger logger;
  final RestClientBase restClientBase;

  // so we did not create same repository twice
  // we created that once and set that inside DependencyContainer
  // and through DependencyContainer we can access that repository
  final IAuthenticationRepository authenticationRepository;

  @override
  UpdateUserBloc create() {
    final IUpdateUserDataSource updateUserDataSource = UpdateUserDataSource(
      logger: logger,
      restClientBase: restClientBase,
    );

    final IUpdateUserRepository updateUserRepository = UpdateUserRepository(
      updateUserDataSource: updateUserDataSource,
    );

    // you can create same repository twice, it doesn't take too much memory
    // because Dart clears the memory of unused objects when it needs to
    // so, that it why you can create the same AuthRepository here
    // or you can create that inside DependencyContainer and use that repository everywhere it's needed

    // same creation of AuthenticationRepository -> take a look at authentication_bloc_factory.dart

    // final IAuthenticationDataSource authenticationRemoteDataSource = AuthenticationRemoteDataSource(
    //   logger: logger,
    //   restClientBase: restClientBase,
    // );

    // final IAuthenticationDataSource autenticationLocalDataSource = AuthenticationLocalDatasource(
    //   logger: logger,
    // );

    // final IAuthenticationRepository authenticationRepository = AuthenticationRepository(
    //   authenticationRemoteDataSource: authenticationRemoteDataSource,
    //   authenticationLocalDataSource: autenticationLocalDataSource,

    //   // it's a singleton, so no need to pass it from the container
    //   internetConnection: InternetConnection(),
    // );

    return UpdateUserBloc(
      updateUserRepository: updateUserRepository,
      initialState: UpdateUserState.initial(user),
      authenticationRepository: authenticationRepository,
    );
  }
}
