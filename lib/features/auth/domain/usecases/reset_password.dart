import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPassword implements UseCase<void, ResetPasswordParams> {
  const ResetPassword(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return _repository.resetPassword(email: params.email);
  }
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}
