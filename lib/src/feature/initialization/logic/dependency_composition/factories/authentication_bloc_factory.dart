import 'package:test_template/src/feature/authentication/bloc/authentication_bloc.dart';
import 'package:test_template/src/feature/authentication/data/authentication_datasource.dart';
import 'package:test_template/src/feature/authentication/data/authentication_repository.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/factories/factory.dart';

final class AuthenticationBlocFactory extends Factory<AuthenticationBloc> {
  @override
  AuthenticationBloc create() {
    final IAuthenticationDataSource authenticationDataSource = AuthenticationDataSource();

    final IAuthenticationRepository repository = AuthenticationRepository(
      authenticationDataSource: authenticationDataSource,
    );

    return AuthenticationBloc(authenticationRepository: repository);
  }
}
