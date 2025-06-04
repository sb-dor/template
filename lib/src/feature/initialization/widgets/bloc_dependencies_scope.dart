import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/factories/authentication_bloc_factory.dart';

class BlocDependenciesScope extends StatelessWidget {
  final Widget child;

  const BlocDependenciesScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthenticationBlocFactory().create())],
      child: child, // const MainMaterialApp(),
    );
  }
}
