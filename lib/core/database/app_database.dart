import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habit_boost/core/sync/sync_table.dart';
import 'package:habit_boost/core/utils/app_logger.dart';
import 'package:habit_boost/features/habits/data/datasources/habits_table.dart';
import 'package:habit_boost/features/journal/data/datasources/journal_table.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    HabitsTable,
    HabitCompletionsTable,
    JournalEntriesTable,
    SyncQueueTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(journalEntriesTable);
        }
        if (from < 3) {
          await m.createTable(syncQueueTable);
          await m.addColumn(habitsTable, habitsTable.updatedAt);
          await m.addColumn(
            habitCompletionsTable,
            habitCompletionsTable.updatedAt,
          );
        }
        if (from < 4) {
          await customStatement(
            'ALTER TABLE habits_table ADD COLUMN '
            "reminder_times TEXT NOT NULL DEFAULT '08:00'",
          );
          await customStatement(
            'UPDATE habits_table SET reminder_times = '
            "printf('%02d:%02d', reminder_hour, reminder_minute)",
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'habit_boost.sqlite'));
    log.i('Database path: ${file.path}');
    return NativeDatabase.createInBackground(file);
  });
}

@module
abstract class DatabaseModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();
}
