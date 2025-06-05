import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_template/src/features/authentication/data/authentication_repository.dart';
import 'package:test_template/src/features/authentication/models/user.dart';
import 'package:test_template/src/features/update_user/data/update_user_repository.dart';

part 'update_user_bloc.freezed.dart';

@immutable
@freezed
sealed class UpdateUserEvent with _$UpdateUserEvent {
  const factory UpdateUserEvent.initial({required User user}) = _UpdateUserInitialEvent;

  const factory UpdateUserEvent.updateUser({required String name, required String email}) =
      _UpdateUserEvent;
}

@immutable
@freezed
sealed class UpdateUserState with _$UpdateUserState {
  const factory UpdateUserState.initial(final User user) = UserUpdateInitialState;

  const factory UpdateUserState.inProgress(final User user) = UserUpdateInProgressState;

  const factory UpdateUserState.failure(final User user, {String? message}) =
      UserUpdateFailureState;

  const factory UpdateUserState.completed(final User user) = UserUpdateCompletedState;
}

// About Coupling (Computer programming):
// 1) https://www.youtube.com/live/AV_4aVOKl-g?si=REBxZ0xBm48Md4zI
// 2) https://www.youtube.com/live/JNA481-HedU?si=gai4Gl_Hw6bHAiOP
//
// ARTICLES:
// 1) https://en.wikipedia.org/wiki/Coupling_(computer_programming)
// 2) https://plugfox.dev/business-logic-component-1/
// 3) https://plugfox.dev/business-logic-component-2/   (scroll down to the end of the article, you will see the structure of the app architecture)
// 4) https://plugfox.dev/business-logic-component-3/
// 5) https://plugfox.dev/business-logic-component-4/
class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  UpdateUserBloc({
    required IUpdateUserRepository updateUserRepository,
    required IAuthenticationRepository authenticationRepository,
    required initialState,
  }) : _updateUserRepository = updateUserRepository,
       _authenticationRepository = authenticationRepository,
       super(initialState) {
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
    on<UpdateUserEvent>(
      (event, emit) => switch (event) {
        final _UpdateUserInitialEvent event => _updateUserInitialEvent(event, emit),
        final _UpdateUserEvent event => _updateUserEvent(event, emit),
      },
    );
  }

  final IUpdateUserRepository _updateUserRepository;

  // if you need a logic that is written in another repository, but you don't want to
  // rewrite same logic in current repository, you can just import that repository from another feature
  // Note: it's not necessary for this Bloc but in order to bring an example closer to real-world usage, I added it
  final IAuthenticationRepository _authenticationRepository;

  void _updateUserInitialEvent(_UpdateUserInitialEvent event, Emitter<UpdateUserState> emit) {
    emit(UpdateUserState.initial(state.user));
  }

  void _updateUserEvent(_UpdateUserEvent event, Emitter<UpdateUserState> emit) async {
    try {
      emit(UpdateUserState.inProgress(state.user));
      final success = await _updateUserRepository.updateUser(name: event.name, email: event.email);
      if (success) {
        emit(UpdateUserState.completed(state.user));
      }
    } catch (error, stackTrace) {
      emit(UpdateUserState.failure(state.user, message: error.toString()));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
