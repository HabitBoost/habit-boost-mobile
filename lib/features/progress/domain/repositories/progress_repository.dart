import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';

/// Repository pattern — kept as class for consistency with other features.
// ignore: one_member_abstracts
abstract class ProgressRepository {
  Future<Either<Failure, ProgressStats>> getProgressStats({
    required String userId,
    required ProgressPeriod period,
  });
}
