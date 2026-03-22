import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:habit_boost/features/progress/domain/repositories/progress_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProgressStats
    extends UseCase<ProgressStats, GetProgressStatsParams> {
  GetProgressStats(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Either<Failure, ProgressStats>> call(
    GetProgressStatsParams params,
  ) {
    return _repository.getProgressStats(
      userId: params.userId,
      period: params.period,
    );
  }
}

class GetProgressStatsParams extends Equatable {
  const GetProgressStatsParams({
    required this.userId,
    required this.period,
  });

  final String userId;
  final ProgressPeriod period;

  @override
  List<Object> get props => [userId, period];
}
