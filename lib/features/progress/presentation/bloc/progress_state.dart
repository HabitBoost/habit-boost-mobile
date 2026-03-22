part of 'progress_bloc.dart';

enum ProgressStatus { initial, loading, loaded, error }

final class ProgressState extends Equatable {
  const ProgressState({
    this.status = ProgressStatus.initial,
    this.stats = ProgressStats.empty,
    this.period = ProgressPeriod.week,
    this.errorMessage,
  });

  final ProgressStatus status;
  final ProgressStats stats;
  final ProgressPeriod period;
  final String? errorMessage;

  ProgressState copyWith({
    ProgressStatus? status,
    ProgressStats? stats,
    ProgressPeriod? period,
    String? errorMessage,
  }) {
    return ProgressState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      period: period ?? this.period,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        stats,
        period,
        errorMessage,
      ];
}
