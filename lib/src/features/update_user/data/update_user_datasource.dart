import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';

abstract interface class IUpdateUserDataSource {
  Future<bool> updateUser({required String name, required String email});
}

// datasources can have try-catch only that time when it's necessary
// otherwise it will be propagated to bloc -> blocObserver -> runZoneGuarded (if blocObserver does not propagate it further)

// more info about Error handling:
// https://lazebny.io/mastering-error-handling/
final class UpdateUserDataSource implements IUpdateUserDataSource {
  UpdateUserDataSource({required this.logger, required this.restClientBase});

  final Logger logger;

  // use for network requests
  final RestClientBase restClientBase;

  @override
  Future<bool> updateUser({required String name, required String email}) async {
    // Simulate a network call or database update
    await Future.delayed(const Duration(seconds: 1));
    // Here you would typically make an API call or database operation to update the user
    return true;
  }
}
