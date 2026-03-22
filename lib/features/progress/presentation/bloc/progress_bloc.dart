import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:habit_boost/features/progress/domain/usecases/get_progress_stats.dart';
import 'package:injectable/injectable.dart';

part 'progress_event.dart';
part 'progress_state.dart';

@injectable
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc({required GetProgressStats getProgressStats})
      : _getProgressStats = getProgressStats,
        super(const ProgressState()) {
    on<ProgressLoadRequested>(_onLoad);
    on<ProgressPeriodChanged>(_onPeriodChanged);
  }

  final GetProgressStats _getProgressStats;
  String? _userId;

  Future<void> _onLoad(
    ProgressLoadRequested event,
    Emitter<ProgressState> emit,
  ) async {
    _userId = event.userId;
    emit(state.copyWith(status: ProgressStatus.loading));

    final result = await _getProgressStats(
      GetProgressStatsParams(
        userId: event.userId,
        period: state.period,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (stats) => emit(
        state.copyWith(
          status: ProgressStatus.loaded,
          stats: stats,
        ),
      ),
    );
  }

  Future<void> _onPeriodChanged(
    ProgressPeriodChanged event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(period: event.period));

    if (_userId != null) {
      add(ProgressLoadRequested(userId: _userId!));
    }
  }
}
