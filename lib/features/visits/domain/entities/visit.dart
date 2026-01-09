import 'package:equatable/equatable.dart';

class Visit extends Equatable {
  final String id;
  final String supervisorId;
  final String customerId;
  final String projectId;
  final DateTime date;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> teamMemberIds;
  final String? serviceReportId;

  const Visit({
    required this.id,
    required this.supervisorId,
    required this.customerId,
    required this.projectId,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.teamMemberIds,
    this.serviceReportId,
  });

  bool get isActive => endTime == null;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  Visit copyWith({
    String? id,
    String? supervisorId,
    String? customerId,
    String? projectId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? teamMemberIds,
    String? serviceReportId,
  }) {
    return Visit(
      id: id ?? this.id,
      supervisorId: supervisorId ?? this.supervisorId,
      customerId: customerId ?? this.customerId,
      projectId: projectId ?? this.projectId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      teamMemberIds: teamMemberIds ?? this.teamMemberIds,
      serviceReportId: serviceReportId ?? this.serviceReportId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        supervisorId,
        customerId,
        projectId,
        date,
        startTime,
        endTime,
        teamMemberIds,
        serviceReportId,
      ];
}

