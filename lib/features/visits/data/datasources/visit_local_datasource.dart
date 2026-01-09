import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/visit_model.dart';

class VisitLocalDataSource {
  final Box<VisitModel> visitBox;
  final Uuid uuid;

  VisitLocalDataSource({
    required this.visitBox,
    required this.uuid,
  });

  Future<VisitModel> createVisit({
    required String supervisorId,
    required String customerId,
    required String projectId,
  }) async {
    final now = DateTime.now();
    final visit = VisitModel(
      id: 'VISIT-${uuid.v4().substring(0, 8).toUpperCase()}',
      supervisorId: supervisorId,
      customerId: customerId,
      projectId: projectId,
      date: DateTime(now.year, now.month, now.day),
      startTime: now,
      teamMemberIds: [],
    );

    await visitBox.put(visit.id, visit);
    return visit;
  }

  Future<VisitModel> endVisit({
    required String visitId,
    required List<String> teamMemberIds,
  }) async {
    final visit = visitBox.get(visitId);
    if (visit == null) {
      throw Exception('Visit not found');
    }

    final updatedVisit = VisitModel(
      id: visit.id,
      supervisorId: visit.supervisorId,
      customerId: visit.customerId,
      projectId: visit.projectId,
      date: visit.date,
      startTime: visit.startTime,
      endTime: DateTime.now(),
      teamMemberIds: teamMemberIds,
      serviceReportId: visit.serviceReportId,
    );

    await visitBox.put(visitId, updatedVisit);
    return updatedVisit;
  }

  Future<VisitModel?> getActiveVisit(String supervisorId) async {
    for (var visit in visitBox.values) {
      if (visit.supervisorId == supervisorId && visit.endTime == null) {
        return visit;
      }
    }
    return null;
  }

  Future<List<VisitModel>> getVisits(String supervisorId) async {
    return visitBox.values
        .where((visit) => visit.supervisorId == supervisorId)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }
}

