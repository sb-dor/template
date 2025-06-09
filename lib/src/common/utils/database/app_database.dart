import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift/drift.dart';
import 'package:test_template/src/common/utils/database/tables/users_table.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// The drift-managed database configuration
/// {@endtemplate}
/// Add tables here
@DriftDatabase(tables: [UsersTable])
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase(super.e);

  /// {@macro app_database}
  AppDatabase.defaults({required String name})
    : super(
        driftDatabase(
          name: name,
          native: const DriftNativeOptions(shareAcrossIsolates: true),
          // TODO(Sizzle): Update the sqlite3Wasm and driftWorker paths to match the location of the files in your project if needed.
          // https://drift.simonbinder.eu/web/#prerequisites
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  // TODO: implement migration
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator mig) async {
        return await mig.createAll();
      },
    );
  }
}
