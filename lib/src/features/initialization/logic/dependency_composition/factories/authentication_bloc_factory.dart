import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_template/src/features/authentication/data/datasource/authentication_datasource.dart';
import 'package:test_template/src/features/authentication/data/authentication_repository.dart';
import 'package:test_template/src/features/authentication/data/datasource/authentication_local_datasource.dart';
import 'package:test_template/src/features/authentication/data/datasource/authentication_remote_datasource.dart';
import 'package:test_template/src/features/initialization/logic/dependency_composition/factories/factory.dart';

final class AuthenticationBlocFactory extends Factory<AuthenticationBloc> {
  AuthenticationBlocFactory({
    required this.logger,
    required this.restClientBase,
    required this.authenticationRepository,
  });

  final Logger logger;
  final RestClientBase restClientBase;
  final IAuthenticationRepository authenticationRepository;

  @override
  AuthenticationBloc create() {
    // you can create same repository twice, it doesn't take too much memory
    // because Dart clears the memory of unused objects when it needs to
    // so, that it why you can create the same AuthRepository here
    // or you can create that inside DependencyContainer and use that repository everywhere it's needed

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

    return AuthenticationBloc(authenticationRepository: authenticationRepository);
  }
}
