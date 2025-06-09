import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/database/app_database.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/common/utils/shared_preferences_helper.dart';
import 'package:test_template/src/features/initialization/logic/dependency_composition/factories/auth_repository_factory.dart';
import 'package:test_template/src/features/initialization/logic/dependency_composition/factories/factory.dart';
import 'package:test_template/src/features/initialization/models/dependency_container.dart';

final class DependencyComposition extends AsyncFactory<DependencyContainer> {
  DependencyComposition({
    required this.logger,
    required this.sharedPreferencesHelper,
    required this.appDatabase,
    required this.restClientBase,
  });

  final Logger logger;
  final SharedPreferencesHelper sharedPreferencesHelper;
  final AppDatabase appDatabase;
  final RestClientBase restClientBase;

  @override
  Future<DependencyContainer> create() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    final iAuthRepository =
        AuthRepositoryFactory(
          logger: logger,
          restClientBase: restClientBase,
          appDatabase: appDatabase,
        ).create();

    return DependencyContainer(
      deviceInfoPlugin: deviceInfoPlugin,
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
      appDatabase: appDatabase,
      restClientBase: restClientBase,
      authenticationRepository: iAuthRepository,
    );
  }
}
