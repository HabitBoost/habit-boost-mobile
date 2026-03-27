import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/features/habits/domain/entities/reminder_time.dart';

void main() {
  group('ReminderTime', () {
    group('toStorageString', () {
      test('форматирует час и минуту с ведущим нулём', () {
        const time = ReminderTime(hour: 8, minute: 5);
        expect(time.toStorageString(), '08:05');
      });

      test('форматирует двузначные значения без нуля', () {
        const time = ReminderTime(hour: 14, minute: 30);
        expect(time.toStorageString(), '14:30');
      });
    });

    group('parse', () {
      test('корректно разбирает строку "08:05"', () {
        final time = ReminderTime.parse('08:05');
        expect(time.hour, 8);
        expect(time.minute, 5);
      });

      test('корректно разбирает строку "14:30"', () {
        final time = ReminderTime.parse('14:30');
        expect(time.hour, 14);
        expect(time.minute, 30);
      });
    });

    group('parseList', () {
      test('возвращает дефолтное значение для пустой строки', () {
        final times = ReminderTime.parseList('');
        expect(times.length, 1);
        expect(times.first, const ReminderTime(hour: 8, minute: 0));
      });

      test('разбирает список из одного значения', () {
        final times = ReminderTime.parseList('09:00');
        expect(times.length, 1);
        expect(times.first, const ReminderTime(hour: 9, minute: 0));
      });

      test('разбирает список из нескольких значений через запятую', () {
        final times = ReminderTime.parseList('08:00,12:30,20:00');
        expect(times.length, 3);
        expect(times[0], const ReminderTime(hour: 8, minute: 0));
        expect(times[1], const ReminderTime(hour: 12, minute: 30));
        expect(times[2], const ReminderTime(hour: 20, minute: 0));
      });
    });

    group('toStorageList', () {
      test('сериализует список в строку через запятую', () {
        final times = [
          const ReminderTime(hour: 8, minute: 0),
          const ReminderTime(hour: 20, minute: 30),
        ];
        expect(ReminderTime.toStorageList(times), '08:00,20:30');
      });

      test('toStorageList и parseList — обратимая операция', () {
        final original = [
          const ReminderTime(hour: 7, minute: 15),
          const ReminderTime(hour: 19, minute: 45),
        ];
        final csv = ReminderTime.toStorageList(original);
        final parsed = ReminderTime.parseList(csv);
        expect(parsed, original);
      });
    });

    group('equality', () {
      test('два объекта с одинаковыми значениями равны', () {
        const a = ReminderTime(hour: 8, minute: 0);
        const b = ReminderTime(hour: 8, minute: 0);
        expect(a, b);
      });

      test('объекты с разными значениями не равны', () {
        const a = ReminderTime(hour: 8, minute: 0);
        const b = ReminderTime(hour: 9, minute: 0);
        expect(a, isNot(b));
      });
    });
  });
}
