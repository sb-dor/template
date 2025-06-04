import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/feature/authentication/bloc/authentication_bloc.dart';
import 'package:test_template/src/feature/authentication/data/datasource/authentication_datasource.dart';
import 'package:test_template/src/feature/authentication/data/authentication_repository.dart';
import 'package:test_template/src/feature/authentication/data/datasource/authentication_local_datasource.dart';
import 'package:test_template/src/feature/authentication/data/datasource/authentication_remote_datasource.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/factories/factory.dart';

final class AuthenticationBlocFactory extends Factory<AuthenticationBloc> {
  AuthenticationBlocFactory({required this.logger, required this.restClientBase});

  final Logger logger;
  final RestClientBase restClientBase;

  @override
  AuthenticationBloc create() {
    final IAuthenticationDataSource authenticationRemoteDataSource = AuthenticationRemoteDataSource(
      logger: logger,
      restClientBase: restClientBase,
    );

    final IAuthenticationDataSource autenticationLocalDataSource = AuthenticationLocalDatasource(
      logger: logger,
    );

    final IAuthenticationRepository repository = AuthenticationRepository(
      authenticationRemoteDataSource: authenticationRemoteDataSource,
      authenticationLocalDataSource: autenticationLocalDataSource,

      // it's a singleton, so no need to pass it from the container
      internetConnection: InternetConnection(),
    );

    return AuthenticationBloc(authenticationRepository: repository);
  }
}
