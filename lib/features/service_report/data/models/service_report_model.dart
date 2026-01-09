import 'package:hive/hive.dart';
import '../../domain/entities/service_report.dart';

part 'service_report_model.g.dart';

@HiveType(typeId: 8)
class ControlledPestModel extends ControlledPest {
  @HiveField(0)
  final String pestId;

  @HiveField(1)
  final String pestName;

  const ControlledPestModel({
    required this.pestId,
    required this.pestName,
  }) : super(
          pestId: pestId,
          pestName: pestName,
        );

  factory ControlledPestModel.fromEntity(ControlledPest pest) {
    return ControlledPestModel(
      pestId: pest.pestId,
      pestName: pest.pestName,
    );
  }

  ControlledPest toEntity() {
    return ControlledPest(
      pestId: pestId,
      pestName: pestName,
    );
  }
}

@HiveType(typeId: 9)
class UsedChemicalModel extends UsedChemical {
  @HiveField(0)
  final String chemicalId;

  @HiveField(1)
  final String chemicalName;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final String unit;

  const UsedChemicalModel({
    required this.chemicalId,
    required this.chemicalName,
    required this.quantity,
    required this.unit,
  }) : super(
          chemicalId: chemicalId,
          chemicalName: chemicalName,
          quantity: quantity,
          unit: unit,
        );

  factory UsedChemicalModel.fromEntity(UsedChemical chemical) {
    return UsedChemicalModel(
      chemicalId: chemical.chemicalId,
      chemicalName: chemical.chemicalName,
      quantity: chemical.quantity,
      unit: chemical.unit,
    );
  }

  UsedChemical toEntity() {
    return UsedChemical(
      chemicalId: chemicalId,
      chemicalName: chemicalName,
      quantity: quantity,
      unit: unit,
    );
  }
}

@HiveType(typeId: 7)
class ServiceReportModel extends ServiceReport {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String visitId;

  @HiveField(2)
  final List<ControlledPestModel> controlledPests;

  @HiveField(3)
  final List<UsedChemicalModel> usedChemicals;

  @HiveField(4)
  final DateTime createdAt;

  const ServiceReportModel({
    required this.id,
    required this.visitId,
    required this.controlledPests,
    required this.usedChemicals,
    required this.createdAt,
  }) : super(
          id: id,
          visitId: visitId,
          controlledPests: controlledPests,
          usedChemicals: usedChemicals,
          createdAt: createdAt,
        );

  factory ServiceReportModel.fromEntity(ServiceReport report) {
    return ServiceReportModel(
      id: report.id,
      visitId: report.visitId,
      controlledPests: report.controlledPests
          .map((p) => ControlledPestModel.fromEntity(p))
          .toList(),
      usedChemicals: report.usedChemicals
          .map((c) => UsedChemicalModel.fromEntity(c))
          .toList(),
      createdAt: report.createdAt,
    );
  }

  ServiceReport toEntity() {
    return ServiceReport(
      id: id,
      visitId: visitId,
      controlledPests: controlledPests.map((p) => p.toEntity()).toList(),
      usedChemicals: usedChemicals.map((c) => c.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}

