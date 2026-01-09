import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/customer.dart';
import '../entities/project.dart';
import '../entities/team_member.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<Customer>>> getCustomers();
  Future<Either<Failure, List<Project>>> getProjectsByCustomerId(String customerId);
  Future<Either<Failure, List<TeamMember>>> getTeamMembers();
}

