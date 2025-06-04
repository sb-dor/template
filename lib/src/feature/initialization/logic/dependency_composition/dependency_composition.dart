import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/database/app_database.dart';
import 'package:test_template/src/common/utils/shared_preferences_helper.dart';
import 'package:test_template/src/feature/initialization/logic/dependency_composition/factories/factory.dart';
import 'package:test_template/src/feature/initialization/models/dependency_container.dart';

final class DependencyComposition extends AsyncFactory<DependencyContainer> {
  DependencyComposition({required final Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  Future<DependencyContainer> create() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final sharedPreferencesHelper = SharedPreferencesHelper();
    await sharedPreferencesHelper.initSharedPrefer();
    final appDatabase = AppDatabase.defaults(name: "test_template.db"); // name of the database

    return DependencyContainer(
      deviceInfoPlugin: deviceInfoPlugin,
      logger: _logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
      appDatabase: appDatabase,
    );
  }
}
