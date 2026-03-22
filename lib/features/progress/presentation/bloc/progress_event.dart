part of 'progress_bloc.dart';

sealed class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

final class ProgressLoadRequested extends ProgressEvent {
  const ProgressLoadRequested({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}

final class ProgressPeriodChanged extends ProgressEvent {
  const ProgressPeriodChanged({required this.period});

  final ProgressPeriod period;

  @override
  List<Object> get props => [period];
}
