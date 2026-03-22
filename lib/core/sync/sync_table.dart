import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get userId => text()();
  TextColumn get action => text()();
  DateTimeColumn get createdAt => dateTime()();
}
