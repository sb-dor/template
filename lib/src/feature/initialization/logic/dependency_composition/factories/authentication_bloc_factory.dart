import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/feature/authentication/bloc/authentication_bloc.dart';
import 'package:test_template/src/feature/authentication/data/authentication_datasource.dart';
import 'package:test_template/src/feature/authentication/data/authentication_repository.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/factories/factory.dart';

final class AuthenticationBlocFactory extends Factory<AuthenticationBloc> {
  AuthenticationBlocFactory({required this.logger, required this.restClientBase});

  final Logger logger;
  final RestClientBase restClientBase;

  @override
  AuthenticationBloc create() {
    final IAuthenticationDataSource authenticationDataSource = AuthenticationDataSource(
      logger: logger,
      restClientBase: restClientBase,
    );

    final IAuthenticationRepository repository = AuthenticationRepository(
      authenticationDataSource: authenticationDataSource,
    );

    return AuthenticationBloc(authenticationRepository: repository);
  }
}
