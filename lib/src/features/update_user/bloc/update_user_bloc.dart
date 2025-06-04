import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  UpdateUserBloc({required IUpdateUserRepository updateUserRepository, required initialState})
    : _updateUserRepository = updateUserRepository,
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
