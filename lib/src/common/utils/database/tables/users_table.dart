import 'package:drift/drift.dart';

// you can delete and create your own tables
// this is just for testing
class UsersTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get email => text().unique()();

  TextColumn get password => text()();

  TextColumn get name => text().nullable()();
}
