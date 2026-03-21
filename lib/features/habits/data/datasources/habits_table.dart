import 'package:drift/drift.dart';

class HabitsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get icon => text().withDefault(const Constant('dumbbell'))();
  TextColumn get color =>
      text().withDefault(const Constant('#4CAF50'))();
  TextColumn get category =>
      text().withDefault(const Constant('Спорт'))();
  TextColumn get scheduleDays =>
      text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get reminderHour =>
      integer().withDefault(const Constant(8))();
  IntColumn get reminderMinute =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get currentStreak =>
      integer().withDefault(const Constant(0))();
  IntColumn get bestStreak =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitCompletionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(HabitsTable, #id)();
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
