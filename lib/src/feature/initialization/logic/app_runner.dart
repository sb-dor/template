import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/bloc/bloc_observer_manager.dart';
import 'package:test_template/src/common/utils/reusable_global_functions.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_template/src/feature/initialization/logic/desktop_initializer.dart';
import 'package:test_template/src/feature/initialization/widgets/io_material_context.dart';
import 'package:test_template/src/feature/initialization/widgets/web_material_context.dart';
import 'dependency_composition/factories/app_logger_factory.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AppRunner {
  //
  Future<void> initialize() async {
    final logger =
        AppLoggerFactory(logFilter: kReleaseMode ? NoOpLogFilter() : DevelopmentFilter()).create();
    //
    await runZonedGuarded(
      () async {
        final binding = WidgetsFlutterBinding.ensureInitialized();

        // for splash screens
        if (ReusableGlobalFunctions.instance.isDesktop) {
          binding.deferFirstFrame();
        } else {
          FlutterNativeSplash.preserve(widgetsBinding: binding);
        }

        // initing the desktop screen sizes
        // I don’t know why— I’m checking whether the platform is limited to desktops, but the web is working anyway.”
        if (!kIsWeb && !kIsWasm && ReusableGlobalFunctions.instance.isDesktop) {
          await DesktopInitializer().run();
        }

        FlutterError.onError = (errorDetails) {
          logger.log(Level.error, errorDetails);
          // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          logger.log(Level.error, "error $error | stacktrace: $stack");
          // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };

        try {
          // bloc concurrency -> should always be sequential -> Pub/sub pattern
          Bloc.transformer = sequential();
          Bloc.observer = BlocObserverManager(logger: logger);

          final dependencyContainer = await DependencyComposition(logger: logger).create();

          late final Widget materialContext;

          if (kIsWeb || kIsWasm) {
            materialContext = WebMaterialContext(dependencyContainer: dependencyContainer);
          } else {
            materialContext = IoMaterialContext(dependencyContainer: dependencyContainer);
          }

          runApp(materialContext);
        } catch (error) {
          rethrow;
        } finally {
          if (ReusableGlobalFunctions.instance.isDesktop) {
            binding.deferFirstFrame();
          } else {
            FlutterNativeSplash.remove();
          }
        }
      },
      (error, stackTrace) {
        logger.log(Level.debug, "Error: $error | stacktrace: $stackTrace");
      },
    );
  }
}
