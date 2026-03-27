import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/create_journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/delete_journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/get_journal_entries.dart';
import 'package:habit_boost/features/journal/domain/usecases/update_journal_entry.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

final _testEntry = JournalEntry(
  id: '1',
  userId: 'user1',
  date: DateTime(2026, 3, 27),
  content: 'Отличный день!',
  mood: Mood.great,
);

void main() {
  late MockJournalRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(_testEntry);
  });

  setUp(() {
    mockRepository = MockJournalRepository();
  });

  group('GetJournalEntries', () {
    test('возвращает список записей при успехе', () async {
      when(() => mockRepository.getEntries(any())).thenAnswer(
        (_) async =>
            Right<Failure, List<JournalEntry>>([_testEntry]),
      );

      final result = await GetJournalEntries(mockRepository)(
        const GetJournalEntriesParams(userId: 'user1'),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('expected Right'),
        (entries) => expect(entries, [_testEntry]),
      );
      verify(() => mockRepository.getEntries('user1')).called(1);
    });

    test('возвращает CacheFailure при ошибке', () async {
      const failure = CacheFailure('Ошибка загрузки');
      when(() => mockRepository.getEntries(any())).thenAnswer(
        (_) async =>
            const Left<Failure, List<JournalEntry>>(failure),
      );

      final result = await GetJournalEntries(mockRepository)(
        const GetJournalEntriesParams(userId: 'user1'),
      );

      expect(result, const Left<Failure, List<JournalEntry>>(failure));
    });

    test('возвращает пустой список если записей нет', () async {
      when(() => mockRepository.getEntries(any())).thenAnswer(
        (_) async =>
            const Right<Failure, List<JournalEntry>>([]),
      );

      final result = await GetJournalEntries(mockRepository)(
        const GetJournalEntriesParams(userId: 'user1'),
      );

      expect(
        result,
        const Right<Failure, List<JournalEntry>>([]),
      );
    });
  });

  group('CreateJournalEntry', () {
    test('возвращает созданную запись при успехе', () async {
      when(() => mockRepository.createEntry(any())).thenAnswer(
        (_) async => Right<Failure, JournalEntry>(_testEntry),
      );

      final result =
          await CreateJournalEntry(mockRepository)(_testEntry);

      expect(result.isRight(), isTrue);
      verify(() => mockRepository.createEntry(_testEntry)).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = ServerFailure('Ошибка сервера');
      when(() => mockRepository.createEntry(any())).thenAnswer(
        (_) async =>
            const Left<Failure, JournalEntry>(failure),
      );

      final result =
          await CreateJournalEntry(mockRepository)(_testEntry);

      expect(
        result,
        const Left<Failure, JournalEntry>(failure),
      );
    });
  });

  group('UpdateJournalEntry', () {
    test('возвращает обновлённую запись при успехе', () async {
      when(() => mockRepository.updateEntry(any())).thenAnswer(
        (_) async => Right<Failure, JournalEntry>(_testEntry),
      );

      final result =
          await UpdateJournalEntry(mockRepository)(_testEntry);

      expect(result.isRight(), isTrue);
      verify(() => mockRepository.updateEntry(_testEntry)).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = CacheFailure('Запись не найдена');
      when(() => mockRepository.updateEntry(any())).thenAnswer(
        (_) async =>
            const Left<Failure, JournalEntry>(failure),
      );

      final result =
          await UpdateJournalEntry(mockRepository)(_testEntry);

      expect(
        result,
        const Left<Failure, JournalEntry>(failure),
      );
    });
  });

  group('DeleteJournalEntry', () {
    test('вызывает deleteEntry с правильным id', () async {
      when(() => mockRepository.deleteEntry(any())).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      final result = await DeleteJournalEntry(mockRepository)(
        const DeleteJournalEntryParams(id: '1'),
      );

      expect(result, const Right<Failure, void>(null));
      verify(() => mockRepository.deleteEntry('1')).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = CacheFailure('Запись не найдена');
      when(() => mockRepository.deleteEntry(any())).thenAnswer(
        (_) async => const Left<Failure, void>(failure),
      );

      final result = await DeleteJournalEntry(mockRepository)(
        const DeleteJournalEntryParams(id: '1'),
      );

      expect(result, const Left<Failure, void>(failure));
    });
  });
}
