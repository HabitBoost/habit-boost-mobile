import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/progress/data/datasources/progress_local_datasource.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:habit_boost/features/progress/domain/repositories/progress_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProgressRepository)
class ProgressRepositoryImpl implements ProgressRepository {
  const ProgressRepositoryImpl(this._local);

  final ProgressLocalDataSource _local;

  @override
  Future<Either<Failure, ProgressStats>> getProgressStats({
    required String userId,
    required ProgressPeriod period,
  }) async {
    try {
      final stats = await _local.getProgressStats(
        userId: userId,
        period: period,
      );
      return Right(stats);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
