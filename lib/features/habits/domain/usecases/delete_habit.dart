import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHabit extends UseCase<void, DeleteHabitParams> {
  DeleteHabit(this._repository);

  final HabitsRepository _repository;

  @override
  Future<Either<Failure, void>> call(DeleteHabitParams params) {
    return _repository.deleteHabit(params.id);
  }
}

class DeleteHabitParams extends Equatable {
  const DeleteHabitParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
