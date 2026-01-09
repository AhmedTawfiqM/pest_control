import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../entities/supervisor.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, Supervisor>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}

