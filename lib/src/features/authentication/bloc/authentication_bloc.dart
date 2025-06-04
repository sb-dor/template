import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_template/src/features/authentication/data/authentication_repository.dart';
import 'package:test_template/src/features/authentication/models/authentication_state_model.dart';

part 'authentication_bloc.freezed.dart';

@immutable
@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.getCurrentUser() = _AuthenticationGetCurrentUser;

  const factory AuthenticationEvent.signIn({required String email, required String password}) =
      _AuthenticationSignIn;

  const factory AuthenticationEvent.signOut() = _AuthenticationSignOut;
}

@immutable
@freezed
sealed class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial(final AuthenticationStateModel stateModel) =
      AuthenticationInitialState;

  const factory AuthenticationState.inProgress(final AuthenticationStateModel stateModel) =
      AuthenticationInProgressState;

  const factory AuthenticationState.failure(
    final AuthenticationStateModel stateModel, {
    final String? message,
  }) = AuthenticationFailureState;

  const factory AuthenticationState.authenticated(final AuthenticationStateModel stateModel) =
      AuthenticationAuthenticatedState;

  const factory AuthenticationState.unauthenticated(final AuthenticationStateModel stateModel) =
      AuthenticationUnauthenticatedState;
}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required IAuthenticationRepository authenticationRepository,
    AuthenticationState? initialState,
  }) : _authenticationRepository = authenticationRepository,
       super(initialState ?? AuthenticationState.initial(AuthenticationStateModel())) {
    //
    //
    // Bloc should have only one event handler.
    // And the absurd part is that even if you do:

    //
    // on<IncEvent>()
    // on<DecEvent>()
    //

    // Sure, each one will now follow its own order of execution.
    // BUT they can still overlap with each other! And the state is shared
    //
    //
    on<AuthenticationEvent>(
      (event, emit) => switch (event) {
        final _AuthenticationGetCurrentUser event => _authenticationGetCurrentUser(event, emit),
        final _AuthenticationSignIn event => _authenticationSignIn(event, emit),
        final _AuthenticationSignOut event => _authenticationSignOut(event, emit),
      },
    );
  }

  final IAuthenticationRepository _authenticationRepository;

  void _authenticationGetCurrentUser(
    _AuthenticationGetCurrentUser event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      // Handle get current user logic
      emit(AuthenticationState.inProgress(state.stateModel));
      // Simulate some initial logic
      final user = await _authenticationRepository.getCurrentUser();

      final currentStateModel = state.stateModel.copyWith(user: user);

      if (user != null) {
        // If user exists, emit authenticated state
        emit(AuthenticationState.authenticated(currentStateModel));
      } else {
        // If no user exists, emit unauthenticated state
        emit(AuthenticationState.unauthenticated(currentStateModel));
      }
    } catch (error, stackTrace) {
      emit(AuthenticationState.failure(state.stateModel, message: error.toString()));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _authenticationSignIn(_AuthenticationSignIn event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationState.inProgress(state.stateModel));

      final user = await _authenticationRepository.signIn(
        email: event.email,
        password: event.password,
      );

      final currentStateModel = state.stateModel.copyWith(user: user);

      if (user != null) {
        // If user exists, emit authenticated state
        emit(AuthenticationState.authenticated(currentStateModel));
      } else {
        // If no user exists, emit unauthenticated state
        emit(AuthenticationState.unauthenticated(currentStateModel));
      }
    } catch (error, stackTrace) {
      emit(AuthenticationState.failure(state.stateModel, message: error.toString()));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _authenticationSignOut(AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    try {
      // Handle sign-out logic
      emit(AuthenticationState.inProgress(state.stateModel));
      // Simulate some sign-out logic
      final success = await _authenticationRepository.signOut();

      if (success) {
        // After sign-out logic, emit unauthenticated state
        emit(AuthenticationState.unauthenticated(state.stateModel));
      }
    } catch (error, stackTrace) {
      emit(AuthenticationState.failure(state.stateModel, message: error.toString()));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
