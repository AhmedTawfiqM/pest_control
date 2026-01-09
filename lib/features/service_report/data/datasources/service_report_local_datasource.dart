import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/chemical_model.dart';
import '../models/pest_model.dart';
import '../models/service_report_model.dart';

class ServiceReportLocalDataSource {
  final Box<PestModel> pestBox;
  final Box<ChemicalModel> chemicalBox;
  final Uuid uuid;

  ServiceReportLocalDataSource({
    required this.pestBox,
    required this.chemicalBox,
    required this.uuid,
  });

  Future<List<PestModel>> getPests() async {
    return pestBox.values.toList();
  }

  Future<List<ChemicalModel>> getChemicals() async {
    return chemicalBox.values.toList();
  }

  Future<ServiceReportModel> submitReport({
    required String visitId,
    required List<String> pestIds,
    required Map<String, double> chemicalQuantities,
  }) async {
    final pests = <ControlledPestModel>[];
    for (var pestId in pestIds) {
      final pest = pestBox.get(pestId);
      if (pest != null) {
        pests.add(ControlledPestModel(
          pestId: pest.id,
          pestName: pest.name,
        ));
      }
    }

    final chemicals = <UsedChemicalModel>[];
    for (var entry in chemicalQuantities.entries) {
      final chemical = chemicalBox.get(entry.key);
      if (chemical != null && entry.value > 0) {
        chemicals.add(UsedChemicalModel(
          chemicalId: chemical.id,
          chemicalName: chemical.name,
          quantity: entry.value,
          unit: chemical.unit,
        ));
      }
    }

    final report = ServiceReportModel(
      id: 'REPORT-${uuid.v4().substring(0, 8).toUpperCase()}',
      visitId: visitId,
      controlledPests: pests,
      usedChemicals: chemicals,
      createdAt: DateTime.now(),
    );

    return report;
  }
}

