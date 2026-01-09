import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/visit.dart';

abstract class VisitRepository {
  Future<Either<Failure, Visit>> createVisit({
    required String supervisorId,
    required String customerId,
    required String projectId,
  });

  Future<Either<Failure, Visit>> endVisit({
    required String visitId,
    required List<String> teamMemberIds,
  });

  Future<Either<Failure, Visit?>> getActiveVisit(String supervisorId);

  Future<Either<Failure, List<Visit>>> getVisits(String supervisorId);
}

