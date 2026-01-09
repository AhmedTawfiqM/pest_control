import 'package:hive/hive.dart';

part 'active_visit_model.g.dart';

@HiveType(typeId: 10)
class ActiveVisitModel {
  @HiveField(0)
  final String customerId;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final String customerName;

  @HiveField(3)
  final String projectName;

  @HiveField(4)
  final DateTime startTimeUtc;

  const ActiveVisitModel({
    required this.customerId,
    required this.projectId,
    required this.customerName,
    required this.projectName,
    required this.startTimeUtc,
  });

  // Calculate duration from start to now
  Duration get duration {
    return DateTime.now().toUtc().difference(startTimeUtc);
  }

  // Get local start time
  DateTime get startTimeLocal {
    return startTimeUtc.toLocal();
  }

  ActiveVisitModel copyWith({
    String? customerId,
    String? projectId,
    String? customerName,
    String? projectName,
    DateTime? startTimeUtc,
  }) {
    return ActiveVisitModel(
      customerId: customerId ?? this.customerId,
      projectId: projectId ?? this.projectId,
      customerName: customerName ?? this.customerName,
      projectName: projectName ?? this.projectName,
      startTimeUtc: startTimeUtc ?? this.startTimeUtc,
    );
  }
}

