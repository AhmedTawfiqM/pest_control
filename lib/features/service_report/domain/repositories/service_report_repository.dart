import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chemical.dart';
import '../entities/pest.dart';
import '../entities/service_report.dart';

abstract class ServiceReportRepository {
  Future<Either<Failure, List<Pest>>> getPests();
  Future<Either<Failure, List<Chemical>>> getChemicals();
  Future<Either<Failure, ServiceReport>> submitReport({
    required String visitId,
    required List<String> pestIds,
    required Map<String, double> chemicalQuantities,
  });
}

