import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/supervisor.dart';

abstract class AuthRepository {
  Future<Either<Failure, Supervisor>> login(String email, String password);
  Future<Either<Failure, Supervisor>> register({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, Supervisor?>> getCurrentUser();
  Future<Either<Failure, void>> logout();
}

