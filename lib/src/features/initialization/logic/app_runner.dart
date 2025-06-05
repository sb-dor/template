import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/bloc/bloc_observer_manager.dart';
import 'package:test_template/src/common/utils/bloc/bloc_transformer.dart';
import 'package:test_template/src/common/utils/database/app_database.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/common/utils/reusable_global_functions.dart';
import 'package:test_template/src/common/utils/shared_preferences_helper.dart';
import 'package:test_template/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_template/src/features/initialization/logic/desktop_initializer.dart';
import 'package:test_template/src/features/initialization/models/application_config.dart';
import 'package:test_template/src/features/initialization/widgets/io_material_context.dart';
import 'package:test_template/src/features/initialization/widgets/web_material_context.dart';
import 'dependency_composition/factories/app_logger_factory.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AppRunner {
  //
  Future<void> initialize() async {
    final ApplicationConfig applicationConfig = ApplicationConfig();

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
          // for more about other concurrency patterns, see https://pub.dev/packages/bloc_concurrency
          // but for now we do not need any pacakge, so we use our created transformer
          Bloc.transformer = SequentialBlocTransformer<Object?>().transform;
          Bloc.observer = BlocObserverManager(logger: logger);

          final sharedPreferHelper = SharedPreferencesHelper();
          await sharedPreferHelper.initSharedPrefer();
          final appDatabase = AppDatabase.defaults(name: applicationConfig.databaseName);

          final RestClientBase restClientBase = RestClientDio(
            logger: logger,
            baseURL: applicationConfig.mainUrl,
            sharedPreferHelper: sharedPreferHelper,
          );

          final dependencyContainer =
              await DependencyComposition(
                logger: logger,
                sharedPreferencesHelper: sharedPreferHelper,
                appDatabase: appDatabase,
                restClientBase: restClientBase,
              ).create();

          late final Widget rootContext;

          if (kIsWeb || kIsWasm) {
            rootContext = WebMaterialContext(dependencyContainer: dependencyContainer);
          } else {
            rootContext = IoMaterialContext(dependencyContainer: dependencyContainer);
          }

          runApp(rootContext);
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
