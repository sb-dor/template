import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_template/src/common/ui_kit/circular_progress_indicator_widget.dart';
import 'package:test_template/src/common/ui_kit/refresh_indicator_widget.dart';
import 'package:test_template/src/feature/authentication/bloc/authentication_bloc.dart';

part "authentication_widget.dart";

class AuthenticationConfigWidget extends StatefulWidget {
  const AuthenticationConfigWidget({super.key});

  @override
  State<AuthenticationConfigWidget> createState() => _AuthenticationConfigWidgetState();
}

class _AuthenticationConfigWidgetState extends State<AuthenticationConfigWidget> {
  // late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    // _authenticationBloc = AuthenticationBloc();
  }

  @override
  dispose() {
    // _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If you want to use already created bloc, uncomment the following line:
    // return BlocProvider.value(value: _authenticationBloc, child: _AuthenticationWidget());
    return _AuthenticationWidget();
  }
}
