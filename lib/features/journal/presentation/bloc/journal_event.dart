part of 'journal_bloc.dart';

sealed class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

final class JournalLoadRequested extends JournalEvent {
  const JournalLoadRequested({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

final class JournalEntryCreated extends JournalEvent {
  const JournalEntryCreated({required this.entry});

  final JournalEntry entry;

  @override
  List<Object?> get props => [entry];
}

final class JournalEntryUpdated extends JournalEvent {
  const JournalEntryUpdated({required this.entry});

  final JournalEntry entry;

  @override
  List<Object?> get props => [entry];
}

final class JournalEntryDeleted extends JournalEvent {
  const JournalEntryDeleted({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
