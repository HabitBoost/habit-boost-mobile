import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/create_journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/delete_journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/get_journal_entries.dart';
import 'package:habit_boost/features/journal/domain/usecases/update_journal_entry.dart';
import 'package:habit_boost/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetJournalEntries extends Mock
    implements GetJournalEntries {}

class MockCreateJournalEntry extends Mock
    implements CreateJournalEntry {}

class MockUpdateJournalEntry extends Mock
    implements UpdateJournalEntry {}

class MockDeleteJournalEntry extends Mock
    implements DeleteJournalEntry {}

void main() {
  late MockGetJournalEntries mockGetEntries;
  late MockCreateJournalEntry mockCreateEntry;
  late MockUpdateJournalEntry mockUpdateEntry;
  late MockDeleteJournalEntry mockDeleteEntry;

  final testEntry = JournalEntry(
    id: '1',
    userId: 'user1',
    date: DateTime(2026, 3, 20),
    content: 'Отличный день!',
    mood: Mood.great,
    tags: const ['Продуктивность'],
  );

  setUpAll(() {
    registerFallbackValue(
      const GetJournalEntriesParams(userId: ''),
    );
    registerFallbackValue(testEntry);
    registerFallbackValue(
      const DeleteJournalEntryParams(id: ''),
    );
  });

  setUp(() {
    mockGetEntries = MockGetJournalEntries();
    mockCreateEntry = MockCreateJournalEntry();
    mockUpdateEntry = MockUpdateJournalEntry();
    mockDeleteEntry = MockDeleteJournalEntry();
  });

  JournalBloc buildBloc() => JournalBloc(
        getJournalEntries: mockGetEntries,
        createJournalEntry: mockCreateEntry,
        updateJournalEntry: mockUpdateEntry,
        deleteJournalEntry: mockDeleteEntry,
      );

  group('JournalLoadRequested', () {
    blocTest<JournalBloc, JournalState>(
      'emits [loading, loaded] with entries on success',
      build: () {
        when(() => mockGetEntries(any()))
            .thenAnswer((_) async => Right([testEntry]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const JournalLoadRequested(userId: 'user1'),
      ),
      expect: () => [
        const JournalState(status: JournalStatus.loading),
        isA<JournalState>()
            .having(
              (s) => s.status,
              'status',
              JournalStatus.loaded,
            )
            .having(
              (s) => s.entries.length,
              'entries length',
              1,
            ),
      ],
    );

    blocTest<JournalBloc, JournalState>(
      'emits [loading, error] on failure',
      build: () {
        when(() => mockGetEntries(any())).thenAnswer(
          (_) async =>
              const Left(CacheFailure('Ошибка загрузки')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const JournalLoadRequested(userId: 'user1'),
      ),
      expect: () => [
        const JournalState(status: JournalStatus.loading),
        const JournalState(
          status: JournalStatus.error,
          errorMessage: 'Ошибка загрузки',
        ),
      ],
    );

    blocTest<JournalBloc, JournalState>(
      'emits loaded with empty list when no entries',
      build: () {
        when(() => mockGetEntries(any()))
            .thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const JournalLoadRequested(userId: 'user1'),
      ),
      expect: () => [
        const JournalState(status: JournalStatus.loading),
        const JournalState(status: JournalStatus.loaded),
      ],
    );
  });

  group('JournalEntryCreated', () {
    blocTest<JournalBloc, JournalState>(
      'calls create and reloads on success',
      build: () {
        when(() => mockCreateEntry(any()))
            .thenAnswer((_) async => Right(testEntry));
        when(() => mockGetEntries(any()))
            .thenAnswer((_) async => Right([testEntry]));
        return buildBloc();
      },
      act: (bloc) {
        bloc
          ..add(
            const JournalLoadRequested(userId: 'user1'),
          )
          ..add(JournalEntryCreated(entry: testEntry));
      },
      verify: (_) {
        verify(() => mockCreateEntry(any())).called(1);
      },
    );
  });

  group('JournalEntryDeleted', () {
    blocTest<JournalBloc, JournalState>(
      'calls delete and reloads on success',
      build: () {
        when(() => mockDeleteEntry(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetEntries(any()))
            .thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (bloc) {
        bloc
          ..add(
            const JournalLoadRequested(userId: 'user1'),
          )
          ..add(const JournalEntryDeleted(id: '1'));
      },
      verify: (_) {
        verify(() => mockDeleteEntry(any())).called(1);
      },
    );
  });
}
