import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
