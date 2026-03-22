import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/create_journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/delete_journal_entry.dart';
import 'package:habit_boost/features/journal/domain/usecases/get_journal_entries.dart';
import 'package:habit_boost/features/journal/domain/usecases/update_journal_entry.dart';
import 'package:injectable/injectable.dart';

part 'journal_event.dart';
part 'journal_state.dart';

@injectable
class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc({
    required GetJournalEntries getJournalEntries,
    required CreateJournalEntry createJournalEntry,
    required UpdateJournalEntry updateJournalEntry,
    required DeleteJournalEntry deleteJournalEntry,
  })  : _getJournalEntries = getJournalEntries,
        _createJournalEntry = createJournalEntry,
        _updateJournalEntry = updateJournalEntry,
        _deleteJournalEntry = deleteJournalEntry,
        super(const JournalState()) {
    on<JournalLoadRequested>(_onLoad);
    on<JournalEntryCreated>(_onCreate);
    on<JournalEntryUpdated>(_onUpdate);
    on<JournalEntryDeleted>(_onDelete);
  }

  final GetJournalEntries _getJournalEntries;
  final CreateJournalEntry _createJournalEntry;
  final UpdateJournalEntry _updateJournalEntry;
  final DeleteJournalEntry _deleteJournalEntry;
  String? _userId;

  Future<void> _onLoad(
    JournalLoadRequested event,
    Emitter<JournalState> emit,
  ) async {
    _userId = event.userId;
    emit(state.copyWith(status: JournalStatus.loading));

    final result = await _getJournalEntries(
      GetJournalEntriesParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: JournalStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (entries) => emit(
        state.copyWith(
          status: JournalStatus.loaded,
          entries: entries,
        ),
      ),
    );
  }

  Future<void> _onCreate(
    JournalEntryCreated event,
    Emitter<JournalState> emit,
  ) async {
    final result = await _createJournalEntry(event.entry);
    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message),
      ),
      (_) {
        if (_userId != null) {
          add(JournalLoadRequested(userId: _userId!));
        }
      },
    );
  }

  Future<void> _onUpdate(
    JournalEntryUpdated event,
    Emitter<JournalState> emit,
  ) async {
    final result = await _updateJournalEntry(event.entry);
    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message),
      ),
      (_) {
        if (_userId != null) {
          add(JournalLoadRequested(userId: _userId!));
        }
      },
    );
  }

  Future<void> _onDelete(
    JournalEntryDeleted event,
    Emitter<JournalState> emit,
  ) async {
    final result = await _deleteJournalEntry(
      DeleteJournalEntryParams(id: event.id),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message),
      ),
      (_) {
        if (_userId != null) {
          add(JournalLoadRequested(userId: _userId!));
        }
      },
    );
  }
}
