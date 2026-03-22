part of 'journal_bloc.dart';

enum JournalStatus { initial, loading, loaded, error }

final class JournalState extends Equatable {
  const JournalState({
    this.status = JournalStatus.initial,
    this.entries = const [],
    this.errorMessage,
  });

  final JournalStatus status;
  final List<JournalEntry> entries;
  final String? errorMessage;

  JournalState copyWith({
    JournalStatus? status,
    List<JournalEntry>? entries,
    String? errorMessage,
  }) {
    return JournalState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, entries, errorMessage];
}
