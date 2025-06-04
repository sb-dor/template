import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_template/src/features/initialization/logic/dependency_composition/factories/authentication_bloc_factory.dart';
import 'package:test_template/src/features/initialization/models/dependency_container.dart';

class BlocDependenciesScope extends StatelessWidget {
  final DependencyContainer dependencyContainer;
  final Widget child;

  const BlocDependenciesScope({super.key, required this.child, required this.dependencyContainer});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  AuthenticationBlocFactory(
                    logger: dependencyContainer.logger,
                    restClientBase: dependencyContainer.restClientBase,
                  ).create(),
        ),
      ],
      child: child, // const MainMaterialApp(),
    );
  }
}
