import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_template/src/feature/authentication/models/user.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/factories/update_user_bloc_factory.dart';
import 'package:test_template/src/feature/initialization/widgets/dependencies_scope.dart';
import 'package:test_template/src/feature/update_user/bloc/update_user_bloc.dart';

part 'update_user_widget.dart';

class UpdateUserConfigWidget extends StatefulWidget {
  const UpdateUserConfigWidget({super.key, required this.user});

  final User user;

  @override
  State<UpdateUserConfigWidget> createState() => _UpdateUserConfigWidgetState();
}

class _UpdateUserConfigWidgetState extends State<UpdateUserConfigWidget> {
  late final UpdateUserBloc _updateUserBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _updateUserBloc =
        UpdateUserBlocFactory(
          user: widget.user,
          restClientBase: dependencies.restClientBase,
          logger: dependencies.logger,
        ).create();
  }

  @override
  void dispose() {
    _updateUserBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _updateUserBloc, child: _UpdateUserWidget(user: widget.user));
  }
}
