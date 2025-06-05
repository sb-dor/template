import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/database/app_database.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/common/utils/shared_preferences_helper.dart';
import 'package:test_template/src/features/authentication/data/authentication_repository.dart';

// for more info about dependency injection, take a look at:
// 1. https://www.youtube.com/live/NiolORe9B4w?si=w8zj6zXNm5g4YuR-
class DependencyContainer {
  DependencyContainer({
    required this.deviceInfoPlugin,
    required this.logger,
    required this.sharedPreferencesHelper,
    required this.appDatabase,
    required this.restClientBase,
    required this.authenticationRepository,
  });

  final DeviceInfoPlugin deviceInfoPlugin;
  final Logger logger;
  final SharedPreferencesHelper sharedPreferencesHelper;
  final AppDatabase appDatabase;
  final RestClientBase restClientBase;
  final IAuthenticationRepository authenticationRepository;
}
