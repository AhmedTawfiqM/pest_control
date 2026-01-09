import 'package:hive/hive.dart';
import '../../domain/entities/visit.dart';

part 'visit_model.g.dart';

@HiveType(typeId: 6)
class VisitModel extends Visit {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String supervisorId;

  @HiveField(2)
  final String customerId;

  @HiveField(3)
  final String projectId;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final DateTime startTime;

  @HiveField(6)
  final DateTime? endTime;

  @HiveField(7)
  final List<String> teamMemberIds;

  @HiveField(8)
  final String? serviceReportId;

  const VisitModel({
    required this.id,
    required this.supervisorId,
    required this.customerId,
    required this.projectId,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.teamMemberIds,
    this.serviceReportId,
  }) : super(
          id: id,
          supervisorId: supervisorId,
          customerId: customerId,
          projectId: projectId,
          date: date,
          startTime: startTime,
          endTime: endTime,
          teamMemberIds: teamMemberIds,
          serviceReportId: serviceReportId,
        );

  factory VisitModel.fromEntity(Visit visit) {
    return VisitModel(
      id: visit.id,
      supervisorId: visit.supervisorId,
      customerId: visit.customerId,
      projectId: visit.projectId,
      date: visit.date,
      startTime: visit.startTime,
      endTime: visit.endTime,
      teamMemberIds: visit.teamMemberIds,
      serviceReportId: visit.serviceReportId,
    );
  }

  Visit toEntity() {
    return Visit(
      id: id,
      supervisorId: supervisorId,
      customerId: customerId,
      projectId: projectId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      teamMemberIds: teamMemberIds,
      serviceReportId: serviceReportId,
    );
  }
}

