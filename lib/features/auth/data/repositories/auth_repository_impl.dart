import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/supervisor.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Supervisor>> login(
      String email, String password) async {
    try {
      final supervisor = await localDataSource.login(email, password);
      if (supervisor == null) {
        return const Left(AuthFailure('Invalid credentials'));
      }
      return Right(supervisor.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Supervisor>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final supervisor = await localDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return Right(supervisor.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Supervisor?>> getCurrentUser() async {
    try {
      final supervisor = await localDataSource.getCurrentUser();
      return Right(supervisor?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

