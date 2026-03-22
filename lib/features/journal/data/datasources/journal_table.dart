import 'package:drift/drift.dart';

class JournalEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get content => text()();
  TextColumn get mood =>
      text().withDefault(const Constant('neutral'))();
  TextColumn get tags =>
      text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
